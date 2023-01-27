Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B54067E524
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 13:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbjA0M2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 07:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbjA0M1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 07:27:43 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C1E116
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 04:27:02 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id f12-20020a7bc8cc000000b003daf6b2f9b9so5294752wml.3
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 04:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8pMkhHFB/0sHM3YaN1HEXuPibcrXDNuPK6D7uK+Id9U=;
        b=lQ/4mVgQiAmuB+FsdsJbbbOkXqgqSj0xsKckH+v+CniakQb7iBWnGboD/TqhaRrT4x
         RYLZX62C3prpzOD+8MqAkiquc+icSpiMD1K3a/aBX8xjQLfot8SRS9bWZHhwrsKunWvq
         pBc5VGfY2E0UnOqUidzcudbindwiRfYR30PM+C53ZQKQ8Al+GUNsKaOkwGMl3HF04ypP
         UWO/uHHTwViKyzYuR2I34mtJI3gOLSGlxgHJc8vJvlUZ/EOUmY2QvsiOpCE8PDMoLwRP
         tcVA3bQvt3GD5sl2AuV2JeFmHBpVB6c8aM1p+RNH9Fw3XmCSvllCYe1zmjK92V3IW9gm
         XXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8pMkhHFB/0sHM3YaN1HEXuPibcrXDNuPK6D7uK+Id9U=;
        b=e8tzIIehu1vK1WF0H9mXKxYgLndnx9zJjp1X0KV/s3m5wNqFLFbeyfsFDcN11lFkXR
         eF4mFn+AXScHQggbzXGtJDgU/ISDzD6vMExFDXKjePKYZBRIeJwZFdYztqpVh0bm2INj
         j6RDCeJxXeZdbLOjqJGu9mUaq+k5vpEdTcvBEGW+vLx/OwzZnoEYHLVRLOl6LkyDjCKv
         2NsXHdNzb4xyMgx9qgvrDLwetGWYoG/wI+q8vKf4O6uA8/U+TeFgUOJfp2Rh5j4Q+f1Z
         zCFP1LWYNJU8vMAynkoosTbObI845l6VOU2IEz9eA/fvarni7OUQCA4ii1GGLGwGJ4IR
         UgYw==
X-Gm-Message-State: AFqh2kq/C+FtyMfDz74QKRYdF/IkZyRCCCEyNo373zFQ6iPtc1FjrG2m
        cwFHcrGLT+qL4UdhXWM/LrA=
X-Google-Smtp-Source: AMrXdXvtnWtG7ri1sXZDtBzNr5sIPtB9DDa2KHwO0KvlhT9RjMZ4PHhjaR5TYwiBx1PCZCzQxoPV2Q==
X-Received: by 2002:a05:600c:224b:b0:3d2:640:c4e5 with SMTP id a11-20020a05600c224b00b003d20640c4e5mr40158948wmm.8.1674822420849;
        Fri, 27 Jan 2023 04:27:00 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id c42-20020a05600c4a2a00b003da105437besm4212106wmp.29.2023.01.27.04.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 04:27:00 -0800 (PST)
Date:   Fri, 27 Jan 2023 12:26:58 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v3 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <Y9PDEkx8/ZEsDR5b@gmail.com>
Mail-Followup-To: "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
References: <20230127093651.54035-1-alejandro.lucero-palau@amd.com>
 <20230127093651.54035-3-alejandro.lucero-palau@amd.com>
 <Y9OzfKzbuSDAD12v@gmail.com>
 <cff1da82-f2c2-773b-b8cb-64ab26d49d9e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cff1da82-f2c2-773b-b8cb-64ab26d49d9e@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:29:08AM +0000, Lucero Palau, Alejandro wrote:
> 
> On 1/27/23 11:20, Martin Habets wrote:
> > On Fri, Jan 27, 2023 at 09:36:45AM +0000, alejandro.lucero-palau@amd.com wrote:
> >> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> >>
> >> Support for devlink info command.
> >>
> >> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> >> ---
> >>   Documentation/networking/devlink/sfc.rst |  57 ++++
> >>   drivers/net/ethernet/sfc/efx_devlink.c   | 404 +++++++++++++++++++++++
> >>   drivers/net/ethernet/sfc/efx_devlink.h   |  17 +
> >>   drivers/net/ethernet/sfc/mcdi.c          |  72 ++++
> >>   drivers/net/ethernet/sfc/mcdi.h          |   3 +
> >>   5 files changed, 553 insertions(+)
> >>   create mode 100644 Documentation/networking/devlink/sfc.rst
> >>

<snip>

> >> index af338208eae9..328cae82a7d8 100644
> >> --- a/drivers/net/ethernet/sfc/mcdi.c
> >> +++ b/drivers/net/ethernet/sfc/mcdi.c
> >> @@ -2308,6 +2308,78 @@ static int efx_mcdi_nvram_update_finish(struct efx_nic *efx, unsigned int type)
> >>   	return rc;
> >>   }
> >>   
> >> +int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
> >> +			    u32 *subtype, u16 version[4], char *desc,
> >> +			    size_t descsize)
> > This is inside an #ifdef CONFIG_SFC_MTD
> > which is why the kernel test robot is reporting the modpost
> > errors.
> > Move it outside of that ifdef.
> >
> > Martin
> 
> 
> I can not see this error report. Maybe, is it coming with further builds 
> not reported yet by patchwork?

See https://lore.kernel.org/netdev/202301251924.Vt4cZmeM-lkp@intel.com/
To reproduce it disable CONFIG_SFC_MTD in your .config, and build with
this series.

Martin

> 
> 
> 
> >
> >> +{
> >> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_METADATA_IN_LEN);
> >> +	efx_dword_t *outbuf;
> >> +	size_t outlen;
> >> +	u32 flags;
> >> +	int rc;
> >> +
> >> +	outbuf = kzalloc(MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2, GFP_KERNEL);
> >> +	if (!outbuf)
> >> +		return -ENOMEM;
> >> +
> >> +	MCDI_SET_DWORD(inbuf, NVRAM_METADATA_IN_TYPE, type);
> >> +
> >> +	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_NVRAM_METADATA, inbuf,
> >> +				sizeof(inbuf), outbuf,
> >> +				MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2,
> >> +				&outlen);
> >> +	if (rc)
> >> +		goto out_free;
> >> +	if (outlen < MC_CMD_NVRAM_METADATA_OUT_LENMIN) {
> >> +		rc = -EIO;
> >> +		goto out_free;
> >> +	}
> >> +
> >> +	flags = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_FLAGS);
> >> +
> >> +	if (desc && descsize > 0) {
> >> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_LBN)) {
> >> +			if (descsize <=
> >> +			    MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)) {
> >> +				rc = -E2BIG;
> >> +				goto out_free;
> >> +			}
> >> +
> >> +			strncpy(desc,
> >> +				MCDI_PTR(outbuf, NVRAM_METADATA_OUT_DESCRIPTION),
> >> +				MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen));
> >> +			desc[MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)] = '\0';
> >> +		} else {
> >> +			desc[0] = '\0';
> >> +		}
> >> +	}
> >> +
> >> +	if (subtype) {
> >> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_LBN))
> >> +			*subtype = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_SUBTYPE);
> >> +		else
> >> +			*subtype = 0;
> >> +	}
> >> +
> >> +	if (version) {
> >> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_LBN)) {
> >> +			version[0] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_W);
> >> +			version[1] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_X);
> >> +			version[2] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Y);
> >> +			version[3] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Z);
> >> +		} else {
> >> +			version[0] = 0;
> >> +			version[1] = 0;
> >> +			version[2] = 0;
> >> +			version[3] = 0;
> >> +		}
> >> +	}
> >> +
> >> +out_free:
> >> +	kfree(outbuf);
> >> +	return rc;
> >> +}
> >> +
> >>   int efx_mcdi_mtd_read(struct mtd_info *mtd, loff_t start,
> >>   		      size_t len, size_t *retlen, u8 *buffer)
> >>   {
> >> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
> >> index 7e35fec9da35..5cb202684858 100644
> >> --- a/drivers/net/ethernet/sfc/mcdi.h
> >> +++ b/drivers/net/ethernet/sfc/mcdi.h
> >> @@ -378,6 +378,9 @@ int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
> >>   			size_t *size_out, size_t *erase_size_out,
> >>   			bool *protected_out);
> >>   int efx_new_mcdi_nvram_test_all(struct efx_nic *efx);
> >> +int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
> >> +			    u32 *subtype, u16 version[4], char *desc,
> >> +			    size_t descsize);
> >>   int efx_mcdi_nvram_test_all(struct efx_nic *efx);
> >>   int efx_mcdi_handle_assertion(struct efx_nic *efx);
> >>   int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);
> >> -- 
> >> 2.17.1
> 
