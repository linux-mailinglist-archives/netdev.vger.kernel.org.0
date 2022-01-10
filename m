Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4463B489DB5
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 17:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbiAJQhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 11:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237593AbiAJQhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 11:37:07 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B32AC06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 08:37:07 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso625046pjb.1
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 08:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=erKQrhpCI58Nnxxbi+YrnqzY0kfbcXSf8rHYBCHrBmE=;
        b=Cc3oQUH0pRzvw0bulmjTa7QiDi9g6JLnBSMpaFYqSpdGJGQdVrjBZCoFSJFEu5GM2V
         OsX3uVbGCQXCA2JpA5T/j2cxPLuJ250E36toXmZl+FZi2G3q8Izf95W9fg4h3p77//Gf
         hx0PgUnIaVmHOKeZ87OQ2Trk812GKniejWato=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=erKQrhpCI58Nnxxbi+YrnqzY0kfbcXSf8rHYBCHrBmE=;
        b=f3X/IKgRYr3zhVd/o8SWPPggqfFjqMAZupFKu8Fz+DJcVjHhg5hYImvrmqCeTTBGUq
         HSo/dXcvCY0P5VrkI6WkRkP2J8ScHkSrhnkhZKSF+WnGWfA/Wx4Wwr58RGaKp5B6JuEK
         XmWuxKAnfN8QVRTmC/S9Mq2IFgVAuNCVCXF8JLOJr1bJJEjGvjtm8Vu0vSMiD93iRMsR
         9wlZiMzeys946Yy3rXd9PxTVXmzM3gWvRobW47Q/VbpfaKHMme+G4vKBRkQPnRyoPHOP
         lIHsSY5Rsk/0pw1Z3i4nRtqw0obB3ceiGZTh4PeOYvDTHee3shVA5AYJhTfeXV4aVDNd
         nl0Q==
X-Gm-Message-State: AOAM533mJOB/UrIzN9M2Vz6AN5q+ZT455+MnJNkm50CHp7czkecgiVo+
        HWh0bre6+8UUF7vGFGBVe6eMNg==
X-Google-Smtp-Source: ABdhPJwuOF4VLD3Had2luICeMwgpPCZmWrpVFPKoDC4/52Sy29r0QnxYswtsP5TzEA0oaZ7EYq5KRg==
X-Received: by 2002:a63:af1e:: with SMTP id w30mr438426pge.467.1641832626191;
        Mon, 10 Jan 2022 08:37:06 -0800 (PST)
Received: from C02YVCJELVCG (104-190-227-136.lightspeed.rlghnc.sbcglobal.net. [104.190.227.136])
        by smtp.gmail.com with ESMTPSA id x12sm3370712pjq.52.2022.01.10.08.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 08:37:05 -0800 (PST)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Mon, 10 Jan 2022 11:37:00 -0500
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com, andy@greyhouse.net
Subject: Re: [PATCH v21 bpf-next 06/23] net: marvell: rely on
 xdp_update_skb_shared_info utility routine
Message-ID: <YdxgrP1YDMyWXmqL@C02YVCJELVCG>
References: <cover.1641641663.git.lorenzo@kernel.org>
 <a346f27e55a9117f43f89aceb7e47c5f0743d50a.1641641663.git.lorenzo@kernel.org>
MIME-Version: 1.0
In-Reply-To: <a346f27e55a9117f43f89aceb7e47c5f0743d50a.1641641663.git.lorenzo@kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008267ea05d53cf226"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008267ea05d53cf226
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 08, 2022 at 12:53:09PM +0100, Lorenzo Bianconi wrote:
> Rely on xdp_update_skb_shared_info routine in order to avoid
> resetting frags array in skb_shared_info structure building
> the skb in mvneta_swbm_build_skb(). Frags array is expected to
> be initialized by the receiving driver building the xdp_buff
> and here we just need to update memory metadata.
> 
> Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 775ffd91b741..267a306d9c75 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2332,8 +2332,12 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
>  		skb_frag_size_set(frag, data_len);
>  		__skb_frag_set_page(frag, page);
>  
> -		if (!xdp_buff_is_mb(xdp))
> +		if (!xdp_buff_is_mb(xdp)) {
> +			sinfo->xdp_frags_size = *size;
>  			xdp_buff_set_mb(xdp);
> +		}
> +		if (page_is_pfmemalloc(page))
> +			xdp_buff_set_frag_pfmemalloc(xdp);
>  	} else {
>  		page_pool_put_full_page(rxq->page_pool, page, true);
>  	}
> @@ -2347,7 +2351,6 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
>  	struct sk_buff *skb;
>  	u8 num_frags;
> -	int i;
>  
>  	if (unlikely(xdp_buff_is_mb(xdp)))
>  		num_frags = sinfo->nr_frags;
> @@ -2362,18 +2365,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  	skb_put(skb, xdp->data_end - xdp->data);
>  	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
>  
> -	if (likely(!xdp_buff_is_mb(xdp)))
> -		goto out;
> -
> -	for (i = 0; i < num_frags; i++) {
> -		skb_frag_t *frag = &sinfo->frags[i];
> -
> -		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> -				skb_frag_page(frag), skb_frag_off(frag),
> -				skb_frag_size(frag), PAGE_SIZE);

Maybe I'm missing something but I'm not sure you have a suitable
replacement for the 3 lines above this in your proposed change.

> -	}
> +	if (unlikely(xdp_buff_is_mb(xdp)))
> +		xdp_update_skb_shared_info(skb, num_frags,
> +					   sinfo->xdp_frags_size,
> +					   num_frags * xdp->frame_sz,
> +					   xdp_buff_is_frag_pfmemalloc(xdp));
>  

When I did an implementation of this on a different driver I also needed
to add:

	for (i = 0; i < num_frags; i++)
		skb_frag_set_page(skb, i, skb_frag_page(&sinfo->frags[i]));

to make sure that frames that were given XDP_PASS were formatted
correctly so they could be handled by the stack.  Don't you need
something similar to make sure frags are properly set?

Thanks,

-andy

P.S.  Sorry for noticing this so late in the process; I realize this version
was just a rebase of v20 and this would have been useful information
earlier if I'm correct.

> -out:
>  	return skb;
>  }
>  
> -- 
> 2.33.1
> 

--0000000000008267ea05d53cf226
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
E90b6DQq048oqwEJMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCnAR3CGjBzZnmI
CqN9MKz0iCVz9RRKJNBSaISQs5js+jAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMjAxMTAxNjM3MDZaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEASGShvmteZKjlc4DsxOHYYM+BY5dGSWhS
hHyffvcHwbN6fyfib6K2Ly5O1QR/zIsAzzKVrKZARWdtojlQ8DuhgvHGZX5/98up2zeWaB36+Wyv
6guquMguT7hssi+MVDtH5yAHksVirStWMOZsI/5HMfRUNqjpM7d+Vs9/Yj7QbJ804cwBcdS9SxUc
FmnT5umxTjyad3mBzFQs6pmgeaRGZ5xmZUtstbmty1UT8MsH1SldcgcNxXz8Cxbzcv+ctqFLeMRQ
qwMJjAJ6mEO4UgbscZF2KcszAnn2JVv/jal/yiK1M9new+b4gEVIqkFbgPc/CG54S0yDeKM/ZUp5
a0Fp0g==
--0000000000008267ea05d53cf226--
