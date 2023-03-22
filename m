Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F476C4472
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 08:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCVHxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 03:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjCVHxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 03:53:49 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DBB5BC95
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 00:53:48 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so22818591pjt.2
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 00:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1679471628;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=syHyjfRRueAEtq6DLKzh6Ls/qIohg57E0hbaaNijI8s=;
        b=NOsqhAoxxTTQlt5XaayTPb++9dA5vzMRfuJWtnsu0HWzyh+A+pkUV0yE426o3mP9fy
         0pzNvz7Z7uXm+E9idhUz8Ymfrr04TWgWVzTexYI+o+ucGJpB32tlEf8zRd42TrGsR4Qx
         j08SPxOEU8KkX1pM3pQk2BN1SbCQIvocIOq+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679471628;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=syHyjfRRueAEtq6DLKzh6Ls/qIohg57E0hbaaNijI8s=;
        b=WSKZOZqb2dox9zfqlPXJcRsGMtGZhJxx2Qru8YVNIvP9ypjvNXbIIAzBPh26fncxLj
         Jy9i79nBhcP/ajzZzt5f+hL2K7enz9Dxh4QfgA9qI+WbGgScNj/4aBWhF3X7e+OUrsAk
         9SEoFqZvBjV17ECIpmIsArDa62xKfl572yvintClLtBKa0Wg7YPCH1UCGW2SuISPwF/r
         dw696+5T5hiLiVbpMUzmTbCbcBoNg7l/VjtQBX9rJvb4ssmONtH6OlMnEWKE1fIgWiXo
         lN41aXtzXB24pFchcjIZKWtbDXWaE8OLYTc9HLP6lFE8kZEJuETmAtetTrVD7V0aS4n7
         VYhQ==
X-Gm-Message-State: AO0yUKUfp/4xM06fMWopwKhsbBYRHeNgTeJOT1vNkFOPzLlJFB6966AO
        aVY+sYFeAa4P2mxVRcE1R3XvkxVUTIPQ7+sc1Ta6/Wxj83PGv4DD9zjdaQ==
X-Google-Smtp-Source: AK7set/9y0CdSKpU0dnWruk3lBarKHyTk0r8yAYceJQZ5LvbUfjrkDTaG+m8wd0N13DPeMvBGnunzb5ZxlTYtfT8fuU=
X-Received: by 2002:a17:902:b7c8:b0:19f:2c5a:5786 with SMTP id
 v8-20020a170902b7c800b0019f2c5a5786mr705496plz.8.1679471627740; Wed, 22 Mar
 2023 00:53:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230321200013.2866582-1-anthony.l.nguyen@intel.com> <20230321200013.2866582-2-anthony.l.nguyen@intel.com>
In-Reply-To: <20230321200013.2866582-2-anthony.l.nguyen@intel.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Wed, 22 Mar 2023 13:23:36 +0530
Message-ID: <CALs4sv0M14fuETdtaKUPziZnZivjXJXwJPyebaAivqZVg_zBog@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] igb: refactor igb_ptp_adjfine_82580 to use diff_by_scaled_ppm
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Andrii Staikov <andrii.staikov@intel.com>,
        richardcochran@gmail.com, Jacob Keller <jacob.e.keller@intel.com>,
        Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000cdd85405f77875d5"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000cdd85405f77875d5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 22, 2023 at 1:32=E2=80=AFAM Tony Nguyen <anthony.l.nguyen@intel=
.com> wrote:
>
> From: Andrii Staikov <andrii.staikov@intel.com>
>
> Driver's .adjfine interface functions use adjust_by_scaled_ppm and
> diff_by_scaled_ppm introduced in commit 1060707e3809
> ("ptp: introduce helpers to adjust by scaled parts per million")
> to calculate the required adjustment in a concise manner,
> but not igb_ptp_adjfine_82580.
> Fix it by introducing IGB_82580_BASE_PERIOD and changing function logic
> to use diff_by_scaled_ppm.
>
> Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A =
Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---

Looks good to me.
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>

>  drivers/net/ethernet/intel/igb/igb_ptp.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ether=
net/intel/igb/igb_ptp.c
> index 6f471b91f562..405886ee5261 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ptp.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
> @@ -67,6 +67,7 @@
>  #define INCVALUE_82576_MASK            GENMASK(E1000_TIMINCA_16NS_SHIFT =
- 1, 0)
>  #define INCVALUE_82576                 (16u << IGB_82576_TSYNC_SHIFT)
>  #define IGB_NBITS_82580                        40
> +#define IGB_82580_BASE_PERIOD          0x800000000
>
>  static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter);
>  static void igb_ptp_sdp_init(struct igb_adapter *adapter);
> @@ -209,17 +210,11 @@ static int igb_ptp_adjfine_82580(struct ptp_clock_i=
nfo *ptp, long scaled_ppm)
>         struct igb_adapter *igb =3D container_of(ptp, struct igb_adapter,
>                                                ptp_caps);
>         struct e1000_hw *hw =3D &igb->hw;
> -       int neg_adj =3D 0;
> +       bool neg_adj;
>         u64 rate;
>         u32 inca;
>
> -       if (scaled_ppm < 0) {
> -               neg_adj =3D 1;
> -               scaled_ppm =3D -scaled_ppm;
> -       }
> -       rate =3D scaled_ppm;
> -       rate <<=3D 13;
> -       rate =3D div_u64(rate, 15625);
> +       neg_adj =3D diff_by_scaled_ppm(IGB_82580_BASE_PERIOD, scaled_ppm,=
 &rate);
>
>         inca =3D rate & INCVALUE_MASK;
>         if (neg_adj)
> --
> 2.38.1
>

--000000000000cdd85405f77875d5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OltyqaGBuzv+bJTUL+bmV7E4QBLIqGt4jVr1R9hJdH6KxXwJdyfHZ9C6qXmoe2NQhiFUyBOJ0wgk
dB9Z1IU7nCwvNKYg2JMoJs93tIgbhPJg/D7pqW8gabkCAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUEV6y/89alKPoFbKUaJXsvWu5
fdowDQYJKoZIhvcNAQELBQADggEBAEHSIB6g652wVb+r2YCmfHW47Jo+5TuCBD99Hla8PYhaWGkd
9HIyD3NPhb6Vb6vtMWJW4MFGQF42xYRrAS4LZj072DuMotr79rI09pbOiWg0FlRRFt6R9vgUgebu
pWSH7kmwVXcPtY94XSMMak4b7RSKig2mKbHDpD4bC7eGlwl5RxzYkgrHtMNRmHmQor5Nvqe52cFJ
25Azqtwvjt5nbrEd81iBmboNTEnLaKuxbbCtLaMEP8xKeDjAKnNOqHUMps0AsQT8c0EGq39YHpjp
Wn1l67VU0rMShbEFsiUf9WYgE677oinpdm0t2mdCjxr35tryxptoTZXKHDxr/Yy6l6ExggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwV/XkICjVscn4SNZMw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOF+81BrwiEVCI9I4j9KI8nGUXaYrdOL
/OC+9eYPXTf8MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDMy
MjA3NTM0OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAd07hPxtHCYcrGU9fMxUt0rtTRADPGdiV0arhIwTLU1KxblJ7y
VTbz3O0z/FXtWftDKKTtaBn3Ap5MTLhO/k6UaKHCBxpas3WK2GlRsSHNiz38t166zpsHLtH99/gj
M3cp11q1nEO115xfCDdpO84tmp+m58YJp1SMKVAS7SojssQjTEihzSLo3kVOoIJgsoGshAAJfDhe
Yb7pMEJ2CKZksTZH4GMdX2XffdOegQOd4mbp0H+kk55doHNVmrbLZQ24kqdxFXo+Es6WPAuqXNYc
iuqq12WLsqAsCPw39J6CDNIFA1nY4K2RmNrhs0LGR6IdElaWJ6aXLleB5B5Ify0C
--000000000000cdd85405f77875d5--
