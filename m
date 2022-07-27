Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3078582674
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbiG0M3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiG0M3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:29:38 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C52C1839B
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:29:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so2007458pjl.0
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=MaXNoC/yRYoi/6URieOS+7U9hYSjaHebgoWJfeBUPgM=;
        b=HJe11QFNw62ccEQR+ZiSbLJ2clArdqDwv2+JHKWvvap6LrkNFYcb4c7vby0umVq3O4
         0nV2skHAas7MutVKlN9s2ZQ/+QhlxumLvVE6Z0+LQfDxXnhYIwB9QW0APrNrmkGFCa2w
         2atozRLIvhQrg76dQUddE+yoo5dwrf49lbWwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=MaXNoC/yRYoi/6URieOS+7U9hYSjaHebgoWJfeBUPgM=;
        b=U9jYOe3KxrsErSnwvUTQ87tO/By/jZfLa6j3P93lwqJe2CstBl/sKxgQJMlAUuUj09
         2huzO7HVaMnw6XeS8UewixIkDUFDkjdgVq+7kTFl7x7bWG5IdWxm3eSY7uncXDRZZatn
         Oy1gO+G+dIsCTsmCjnctLocJLDmUSYAo/58hiwno1kJ0bW185vrX5PaUkEbYsnr0Mg6U
         dBWv9uJ33siuXMrLSJdD3xwoPvQhwyMZ20hqyDrRdHObRDQfNKV5YXaXbGuezKDAmC6J
         6ITeFVgU6/Pp8LwM98OFn/1slqN1HvcgD8z7NvwOBxR1P0xIzpaGqxSufdJjgKyqwdKo
         c9yA==
X-Gm-Message-State: AJIora/9NyjP1vSFezqu3drwdoKrX7q3++yHbtXVrPtrCYX3ZJ0YwNhh
        5GBZL4Fy3+31HIVirXqF+GJtiQ==
X-Google-Smtp-Source: AGRyM1ut/WMG8cPKLDrqpRT1uSMqBpxfSYgPaesK22ByO+bxnQ4D7sqBBg4V4uD7JYRGserZ9hG+fQ==
X-Received: by 2002:a17:902:cf09:b0:16d:6a06:f994 with SMTP id i9-20020a170902cf0900b0016d6a06f994mr15826932plg.62.1658924976969;
        Wed, 27 Jul 2022 05:29:36 -0700 (PDT)
Received: from C02YVCJELVCG (104-190-227-136.lightspeed.rlghnc.sbcglobal.net. [104.190.227.136])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902d18100b0016daa36c745sm2595383plb.299.2022.07.27.05.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 05:29:34 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Wed, 27 Jul 2022 08:29:30 -0400
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v8 2/2] bnxt_en: implement callbacks for devlink
 selftests
Message-ID: <YuEvqlH7kCzLw6zb@C02YVCJELVCG>
References: <20220727092035.35938-1-vikas.gupta@broadcom.com>
 <20220727092035.35938-3-vikas.gupta@broadcom.com>
MIME-Version: 1.0
In-Reply-To: <20220727092035.35938-3-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000fba9b605e4c8919a"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000fba9b605e4c8919a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 27, 2022 at 02:50:35PM +0530, Vikas Gupta wrote:
> From: vikas <vikas.gupta@broadcom.com>
> 
> Add callbacks
> =============
> .selftest_check: returns true for flash selftest.
> .selftest_run: runs a flash selftest.
> 
> Also, refactor NVM APIs so that they can be
> used with devlink and ethtool both.
> 
> Signed-off-by: vikas <vikas.gupta@broadcom.com>
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>

> ---
>  .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 61 +++++++++++++++++++
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 24 ++++----
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h | 12 ++++
>  3 files changed, 85 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> index 6b3d4f4c2a75..14df8cfc2946 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> @@ -20,6 +20,8 @@
>  #include "bnxt_ulp.h"
>  #include "bnxt_ptp.h"
>  #include "bnxt_coredump.h"
> +#include "bnxt_nvm_defs.h"
> +#include "bnxt_ethtool.h"
>  
>  static void __bnxt_fw_recover(struct bnxt *bp)
>  {
> @@ -610,6 +612,63 @@ static int bnxt_dl_reload_up(struct devlink *dl, enum devlink_reload_action acti
>  	return rc;
>  }
>  
> +static bool bnxt_nvm_test(struct bnxt *bp, struct netlink_ext_ack *extack)
> +{
> +	u32 datalen;
> +	u16 index;
> +	u8 *buf;
> +
> +	if (bnxt_find_nvram_item(bp->dev, BNX_DIR_TYPE_VPD,
> +				 BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
> +				 &index, NULL, &datalen) || !datalen) {
> +		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd entry error");
> +		return false;
> +	}
> +
> +	buf = kzalloc(datalen, GFP_KERNEL);
> +	if (!buf) {
> +		NL_SET_ERR_MSG_MOD(extack, "insufficient memory for nvm test");
> +		return false;
> +	}
> +
> +	if (bnxt_get_nvram_item(bp->dev, index, 0, datalen, buf)) {
> +		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd read error");
> +		goto err;
> +	}
> +
> +	if (bnxt_flash_nvram(bp->dev, BNX_DIR_TYPE_VPD, BNX_DIR_ORDINAL_FIRST,
> +			     BNX_DIR_EXT_NONE, 0, 0, buf, datalen)) {
> +		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd write error");
> +		goto err;
> +	}
> +
> +	return true;
> +
> +err:
> +	kfree(buf);
> +	return false;
> +}
> +
> +static bool bnxt_dl_selftest_check(struct devlink *dl, unsigned int id,
> +				   struct netlink_ext_ack *extack)
> +{
> +	return id == DEVLINK_ATTR_SELFTEST_ID_FLASH;
> +}
> +
> +static enum devlink_selftest_status bnxt_dl_selftest_run(struct devlink *dl,
> +							 unsigned int id,
> +							 struct netlink_ext_ack *extack)
> +{
> +	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
> +
> +	if (id == DEVLINK_ATTR_SELFTEST_ID_FLASH)
> +		return bnxt_nvm_test(bp, extack) ?
> +				DEVLINK_SELFTEST_STATUS_PASS :
> +				DEVLINK_SELFTEST_STATUS_FAIL;
> +
> +	return DEVLINK_SELFTEST_STATUS_SKIP;
> +}
> +
>  static const struct devlink_ops bnxt_dl_ops = {
>  #ifdef CONFIG_BNXT_SRIOV
>  	.eswitch_mode_set = bnxt_dl_eswitch_mode_set,
> @@ -622,6 +681,8 @@ static const struct devlink_ops bnxt_dl_ops = {
>  	.reload_limits	  = BIT(DEVLINK_RELOAD_LIMIT_NO_RESET),
>  	.reload_down	  = bnxt_dl_reload_down,
>  	.reload_up	  = bnxt_dl_reload_up,
> +	.selftest_check	  = bnxt_dl_selftest_check,
> +	.selftest_run	  = bnxt_dl_selftest_run,
>  };
>  
>  static const struct devlink_ops bnxt_vf_dl_ops;
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index 7191e5d74208..87eb5362ad70 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -2176,14 +2176,14 @@ static void bnxt_print_admin_err(struct bnxt *bp)
>  	netdev_info(bp->dev, "PF does not have admin privileges to flash or reset the device\n");
>  }
>  
> -static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
> -				u16 ext, u16 *index, u32 *item_length,
> -				u32 *data_length);
> +int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
> +			 u16 ext, u16 *index, u32 *item_length,
> +			 u32 *data_length);
>  
> -static int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
> -			    u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
> -			    u32 dir_item_len, const u8 *data,
> -			    size_t data_len)
> +int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
> +		     u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
> +		     u32 dir_item_len, const u8 *data,
> +		     size_t data_len)
>  {
>  	struct bnxt *bp = netdev_priv(dev);
>  	struct hwrm_nvm_write_input *req;
> @@ -2836,8 +2836,8 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
>  	return rc;
>  }
>  
> -static int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
> -			       u32 length, u8 *data)
> +int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
> +			u32 length, u8 *data)
>  {
>  	struct bnxt *bp = netdev_priv(dev);
>  	int rc;
> @@ -2871,9 +2871,9 @@ static int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
>  	return rc;
>  }
>  
> -static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
> -				u16 ext, u16 *index, u32 *item_length,
> -				u32 *data_length)
> +int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
> +			 u16 ext, u16 *index, u32 *item_length,
> +			 u32 *data_length)
>  {
>  	struct hwrm_nvm_find_dir_entry_output *output;
>  	struct hwrm_nvm_find_dir_entry_input *req;
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> index a59284215e78..a8ecef8ab82c 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> @@ -58,5 +58,17 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
>  int bnxt_get_pkginfo(struct net_device *dev, char *ver, int size);
>  void bnxt_ethtool_init(struct bnxt *bp);
>  void bnxt_ethtool_free(struct bnxt *bp);
> +int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
> +			 u16 ext, u16 *index, u32 *item_length,
> +			 u32 *data_length);
> +int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
> +			 u16 ext, u16 *index, u32 *item_length,
> +			 u32 *data_length);
> +int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
> +		     u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
> +		     u32 dir_item_len, const u8 *data,
> +		     size_t data_len);
> +int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
> +			u32 length, u8 *data);
>  
>  #endif
> -- 
> 2.31.1
> 



--000000000000fba9b605e4c8919a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVkwggRBoAMCAQICDBPdG+g0KtOPKKsBCTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDAyMzhaFw0yMjA5MjIxNDExNTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGDAWBgNVBAMTD0FuZHkgR29zcG9kYXJlazEtMCsGCSqGSIb3
DQEJARYeYW5kcmV3Lmdvc3BvZGFyZWtAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAp9JFtMqwgpbnvA3lNVCpnR5ehv0kWK9zMpw2VWslbEZq4WxlXr1zZLZEFo9Y
rdIZ0jlxwJ4QGYCvxE093p9easqc7NMemeMg7JpF63hhjCksrGnsxb6jCVUreXPSpBDD0cjaE409
9yo/J5OQORNPelDd4Ihod6g0XlcxOLtlTk1F0SOODSjBZvaDm0zteqiVZb+7xgle3NOSZm3kiCby
iRuyS0gMTdQN3gdgwal9iC3cSXHMZFBXyQz+JGSHomhPC66L6j4t6dUqSTdSP07wg38ZPV6ct/Sv
/O2HcK+E/yYkdMXrDBgcOelO4t8AYHhmedCIvFVp4pFb2oit9tBuFQIDAQABo4IB3zCCAdswDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDApBgNVHREEIjAggR5hbmRyZXcuZ29zcG9kYXJla0Bicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYI
KwYBBQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFKARn7Ud
RlGu+rBdUDirYE+Ee4TeMA0GCSqGSIb3DQEBCwUAA4IBAQAcWqh4fdwhDN0+MKyH7Mj0vS10E7xg
mDetQhQ+twwKk5qPe3tJXrjD/NyZzrUgguNaE+X97jRsEbszO7BqdnM0j5vLDOmzb7d6qeNluJvk
OYyzItlqZk9cJPoP9sD8w3lr2GRcajj5JCKV4pd2PX/i7r30Qco0VnloXpiesFmNTXQqD6lguUyn
nb7IGM3v/Nb7NTFH8/KUVg33xw829ztuGrOvfrHfBbeVcUoOHEHObXoaofYOJjtmSOQdMeJIiBgP
XEpJG8/HB8t4FF6A8W++4cHhv0+ayyEnznrbOCn6WUmIvV2WiJymRpvRG7Hhdlk0zA97MRpqK5yn
ai3dQ6VvMYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBu
di1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIM
E90b6DQq048oqwEJMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCzextBYOBE6FiY
zt6mKEVBEsAI8AKZ7uiJDl5b0qdaVjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMjA3MjcxMjI5MzdaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAPTDES9aYKj5H/KEtyiH8cvX0vTEpUvZR
ZuTdUefwGWUniIQMcTFVfR5yZC27AxBE/OPvlW/0/sR9Q81PdupFudvb9KpShlFuzshVYTvyOYm0
5qBVJZmKtk4FzJb2v1gdkR/47MfDQ8rPYXQsdmKxVpuVPm/apJFVVJK3H9QgId1vxD7PoNevMutk
OmQJWQ/W+utt5714jFSdAa4qu+XrM30OGPlCSomUL/o5aVEu6OUzNI9i70avaSDJOXDGa2MyDhGt
VFQ3kc8TLl5FZlc9s6Z33MV3UcIInvEqagvA2DAlF3iqECMnW+Z3fgGR9qfFFxlox5ZVHOurPKin
hS69/Q==
--000000000000fba9b605e4c8919a--
