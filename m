Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197216DE312
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjDKRsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjDKRsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:48:15 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEC561B2
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:48:08 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e22so8322071wra.6
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1681235287; x=1683827287;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=poNNxXLjBm75HYS63dGtvpVacbUwB2f9ytVmkoRj87o=;
        b=KUgKKI6HgBvK8GJtMX2iwf+L4QyxNkLNP5GyZqSSG9TLSi0pIdKeKYjNB8p5mjH6lR
         +b+J3z+CmaNtsEHm5T5h5nBMcNtan2Uw1AWBWbLJYJN4Yu2xMEKeTGIjoIx6jCuxVclO
         FR031hoiuxt3yuQhH+K90cbmnRVka7WwzIy4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681235287; x=1683827287;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=poNNxXLjBm75HYS63dGtvpVacbUwB2f9ytVmkoRj87o=;
        b=XlxnvSplCKT7KohCWlWhQ+utJ9z1eC4hwnsOJBMGJ5kG9/aQbgI/xptKBIsc9dVRZY
         R/mhBv+sYISFAbPuzje9c7RIwsNWpgvciFPNsmGcwTM0M/8XIi8apne7agb7lCr0O7Iw
         8wDb39/Ur4U1f5imXXH1ee5zcJrkHoJLjoy0ufcbwYKW30KirkxuQeQpOf72vqOb/HXi
         8Aq0zG/3rqmLvrw18M2+I7yxE/9d6++K4wpFo+guGqNEt1PN4+jGcxv5U+A94ozbSKGt
         Gbbhm6HYPbrlK1XKvkW4tPn58ztiz7MHq2mm8H8hgSj7mixiDFySzldxb0u5w3NYGvRa
         ZYfA==
X-Gm-Message-State: AAQBX9dJUELf/WIlwiLheIlh7/uWRgWArTjsTUrPXcZordeD/I0bd46Q
        Gi5uxt5L4mRon3l0udXHQfUyfXXWWIIwsSA3k/J8zzQ9RgoLAitTvR4izt22KdcQdBdOAk3ttMr
        4X7H7Dx/JlweoOE3+um0U5UTOG8E9obdS3/D8
X-Google-Smtp-Source: AKy350ZJX1I2JzXaUmEzNNZXAqUDVnSm8PzC5Qh6R3f0ByWI+oThTk9ycKcqUcSDugmpbbWpkAmWF9ng/Ob7FM+JFFw=
X-Received: by 2002:adf:e491:0:b0:2f0:21ee:792c with SMTP id
 i17-20020adfe491000000b002f021ee792cmr1476011wrm.8.1681235287061; Tue, 11 Apr
 2023 10:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230411120443.126055-1-ivecera@redhat.com> <CACKFLimBqwsX3tsnUp9svqSJHx57XEAu3kQ8Hj1Pq0+QS1uGsg@mail.gmail.com>
In-Reply-To: <CACKFLimBqwsX3tsnUp9svqSJHx57XEAu3kQ8Hj1Pq0+QS1uGsg@mail.gmail.com>
From:   Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
Date:   Tue, 11 Apr 2023 23:17:55 +0530
Message-ID: <CADFzAK-ym-LH_suYgHn+wZvh2NGHmiGvRrRxNSa8CbXP=edS9g@mail.gmail.com>
Subject: Re: [PATCH net-next v2] bnxt_en: Allow to set switchdev mode without
 existing VFs
To:     ivecera@redhat.com, netdev@vger.kernel.org
Cc:     mschmidt@redhat.com, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        open list <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001860fd05f913186e"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000001860fd05f913186e
Content-Type: text/plain; charset="UTF-8"

> Remove an inability of bnxt_en driver to set eswitch to switchdev
> mode without existing VFs by:
>
> 1. Allow to set switchdev mode in bnxt_dl_eswitch_mode_set() so
>    representors are created only when num_vfs > 0 otherwise just
>    set bp->eswitch_mode
> 2. Do not automatically change bp->eswitch_mode during
>    bnxt_vf_reps_create() and bnxt_vf_reps_destroy() calls so
>    the eswitch mode is managed only by an user by devlink.
>    Just set temporarily bp->eswitch_mode to legacy to avoid
>    re-opening of representors during destroy.
> 3. Create representors in bnxt_sriov_enable() if current eswitch
>    mode is switchdev one
>
> Tested by this sequence:
> 1. Set PF interface up
> 2. Set PF's eswitch mode to switchdev
> 3. Created N VFs
> 4. Checked that N representors were created
> 5. Set eswitch mode to legacy
> 6. Checked that representors were deleted
> 7. Set eswitch mode back to switchdev
> 8. Checked that representors exist again for VFs
> 9. Deleted all VFs
> 10. Checked that all representors were deleted as well
> 11. Checked that current eswitch mode is still switchdev
>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Acked-by: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
> ---
>  .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   | 16 ++++++++++
>  drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 29 ++++++++++++-------
>  drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h |  6 ++++
>  3 files changed, 41 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
> b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
> index 3ed3a2b3b3a9..dde327f2c57e 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
> @@ -825,8 +825,24 @@ static int bnxt_sriov_enable(struct bnxt *bp, int *num_vfs)
>         if (rc)
>                 goto err_out2;
>
> +       if (bp->eswitch_mode != DEVLINK_ESWITCH_MODE_SWITCHDEV)
> +               return 0;
> +
> +       /* Create representors for VFs in switchdev mode */
> +       devl_lock(bp->dl);
> +       rc = bnxt_vf_reps_create(bp);
> +       devl_unlock(bp->dl);
> +       if (rc) {
> +               netdev_info(bp->dev, "Cannot enable VFS as
> representors cannot be created\n");
> +               goto err_out3;
> +       }
> +
>         return 0;
>
> +err_out3:
> +       /* Disable SR-IOV */
> +       pci_disable_sriov(bp->pdev);
> +
>  err_out2:
>         /* Free the resources reserved for various VF's */
>         bnxt_hwrm_func_vf_resource_free(bp, *num_vfs);
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> index fcc65890820a..2f1a1f2d2157 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> @@ -356,10 +356,15 @@ void bnxt_vf_reps_destroy(struct bnxt *bp)
>         /* un-publish cfa_code_map so that RX path can't see it anymore */
>         kfree(bp->cfa_code_map);
>         bp->cfa_code_map = NULL;
> -       bp->eswitch_mode = DEVLINK_ESWITCH_MODE_LEGACY;
>
> -       if (closed)
> +       if (closed) {
> +               /* Temporarily set legacy mode to avoid re-opening
> +                * representors and restore switchdev mode after that.
> +                */
> +               bp->eswitch_mode = DEVLINK_ESWITCH_MODE_LEGACY;
>                 bnxt_open_nic(bp, false, false);
> +               bp->eswitch_mode = DEVLINK_ESWITCH_MODE_SWITCHDEV;
> +       }
>         rtnl_unlock();
>
>         /* Need to call vf_reps_destroy() outside of rntl_lock
> @@ -482,7 +487,7 @@ static void bnxt_vf_rep_netdev_init(struct bnxt
> *bp, struct bnxt_vf_rep *vf_rep,
>         dev->min_mtu = ETH_ZLEN;
>  }
>
> -static int bnxt_vf_reps_create(struct bnxt *bp)
> +int bnxt_vf_reps_create(struct bnxt *bp)
>  {
>         u16 *cfa_code_map = NULL, num_vfs = pci_num_vf(bp->pdev);
>         struct bnxt_vf_rep *vf_rep;
> @@ -535,7 +540,6 @@ static int bnxt_vf_reps_create(struct bnxt *bp)
>
>         /* publish cfa_code_map only after all VF-reps have been initialized */
>         bp->cfa_code_map = cfa_code_map;
> -       bp->eswitch_mode = DEVLINK_ESWITCH_MODE_SWITCHDEV;
>         netif_keep_dst(bp->dev);
>         return 0;
>
> @@ -559,6 +563,7 @@ int bnxt_dl_eswitch_mode_set(struct devlink
> *devlink, u16 mode,
>                              struct netlink_ext_ack *extack)
>  {
>         struct bnxt *bp = bnxt_get_bp_from_dl(devlink);
> +       int ret = 0;
>
>         if (bp->eswitch_mode == mode) {
>                 netdev_info(bp->dev, "already in %s eswitch mode\n",
> @@ -570,7 +575,7 @@ int bnxt_dl_eswitch_mode_set(struct devlink
> *devlink, u16 mode,
>         switch (mode) {
>         case DEVLINK_ESWITCH_MODE_LEGACY:
>                 bnxt_vf_reps_destroy(bp);
> -               return 0;
> +               break;
>
>         case DEVLINK_ESWITCH_MODE_SWITCHDEV:
>                 if (bp->hwrm_spec_code < 0x10803) {
> @@ -578,15 +583,19 @@ int bnxt_dl_eswitch_mode_set(struct devlink
> *devlink, u16 mode,
>                         return -ENOTSUPP;
>                 }
>
> -               if (pci_num_vf(bp->pdev) == 0) {
> -                       netdev_info(bp->dev, "Enable VFs before
> setting switchdev mode\n");
> -                       return -EPERM;
> -               }
> -               return bnxt_vf_reps_create(bp);
> +               /* Create representors for existing VFs */
> +               if (pci_num_vf(bp->pdev) > 0)
> +                       ret = bnxt_vf_reps_create(bp);
> +               break;
>
>         default:
>                 return -EINVAL;
>         }
> +
> +       if (!ret)
> +               bp->eswitch_mode = mode;
> +
> +       return ret;
>  }
>
>  #endif
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
> b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
> index 5637a84884d7..33a965631d0b 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
> @@ -14,6 +14,7 @@
>
>  #define        MAX_CFA_CODE                    65536
>
> +int bnxt_vf_reps_create(struct bnxt *bp);
>  void bnxt_vf_reps_destroy(struct bnxt *bp);
>  void bnxt_vf_reps_close(struct bnxt *bp);
>  void bnxt_vf_reps_open(struct bnxt *bp);
> @@ -37,6 +38,11 @@ int bnxt_dl_eswitch_mode_set(struct devlink
> *devlink, u16 mode,
>
>  #else
>
> +static inline int bnxt_vf_reps_create(struct bnxt *bp)
> +{
> +       return 0;
> +}
> +
>  static inline void bnxt_vf_reps_close(struct bnxt *bp)
>  {
>  }
> --
> 2.39.2

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--0000000000001860fd05f913186e
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
XzCCBVwwggREoAMCAQICDCuanYaakePGC/8NWzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwODE4MTRaFw0yNTA5MTAwODE4MTRaMIGX
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFzAVBgNVBAMTDlZlbmthdCBEdXZ2dXJ1MS8wLQYJKoZIhvcN
AQkBFiB2ZW5rYXRrdW1hci5kdXZ2dXJ1QGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAKxQsw3EQE2uM7KS4ZepVKluwbllBYQqIXlkB3XAU4vFiPf5M6vxnpPTEVSQ
pXMAwABUFyhDGOZhAVRWonASGLmZYRCHPLVwpTEdjfa0lAimqpRXim9bT5fwESDzC09sQD9e12aQ
0gcj/W45N93AdIDGwS1i+2OrO0dHmhzFjoNZRosPxbMBqk2uK/Y+6MnOmQNhbLC/dkz8ZzMdCXxR
uyfQbbJtM4W4zD0pHaoWT+pT/ZiABohxZUhvDhUAd2dHJOUiWHbOhj2ScdB+xjKgXS6LVUYNyXtD
Ec5y29pHY+8si/7leitRmTHIfES74fzXq1E89h3t4+Nic4Y2q500A/cCAwEAAaOCAeEwggHdMA4G
A1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1
cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBB
BggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2ln
bjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8v
d3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDyg
OoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5j
cmwwKwYDVR0RBCQwIoEgdmVua2F0a3VtYXIuZHV2dnVydUBicm9hZGNvbS5jb20wEwYDVR0lBAww
CgYIKwYBBQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFDs1
MU4IAUcnU7t14K2BAIiIz8LZMA0GCSqGSIb3DQEBCwUAA4IBAQCQ1rmRUDQIugdVsWi1QejVhL+g
CL/yMVayz0o0GeCW3Mu1kEK/vBrbzG7FLDqf0/4yZkFpoPqr0e1ZLdgOuSMkKV0L5q0rILiP9iuU
imekxZsnelVR6/EVFhatVlBpPRsU2EoS+y1o2uoQp2H6j22bywnH14GntFcp7qFvCxKFmd+MnHPs
Vfo7DgaEsngLM08mbO8+1+GnVwJYhJejFbGsSe5SPfZ2YPErgEvoOGAcLmcfBwD8JwRCGL1S+mv3
MqhYMCUkzC+bboRk7fA0KC8cmnLknQxFOP4wgn5TXkqjHdfwI7/gF4j6YZ3fPAm/Y6YcTWrR+3bp
mpJiM3R8PAtwMYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2ln
biBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAy
MAIMK5qdhpqR48YL/w1bMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCDC13DdaAfz
PAOudc02mjiMccFKlt9KcyvdwxMZ9Evs7jAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqG
SIb3DQEJBTEPFw0yMzA0MTExNzQ4MDdaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsG
CWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3
DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAc2y/8REZxgKZukd901wBUHV5Gp00
bI6lk6KQTxhUR377NrXo66Y6iwdbnDggeuVIHIAnOIxNqTT3IBm4bIKZw/Sr6P10QA+D6qmXLFQN
J6PYUMxfV7q5klysoLpbyAl+ngICmyu/9lpEAQzVP8CcL5oQWtPrI8B+B6MQbeGBkrvYm0hbvPEg
yNJwuP8bN9TznwTM631vj4H3smcRCCWu7CQIMSQszAGsgu8UGJz6F83b2+3aw+HimqtQeeAZh/eY
A1ZNALWI6PHoauamkDL8iStuJzWJeqDqIl2g6Ei2vuuyMYY3jZPpjwAl4GeFXe0Omdc8fUdrSysS
0+u9dhM5mA==
--0000000000001860fd05f913186e--
