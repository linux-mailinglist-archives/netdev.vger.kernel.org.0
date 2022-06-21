Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42AF5538BB
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 19:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353181AbiFURRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 13:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353078AbiFURQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 13:16:37 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37782C115
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 10:16:34 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id k14so1620937plh.4
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 10:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=De/YPVJfANZHcQoM3xdk0dmtPOk60iDgsIGhB4FUjTk=;
        b=EtuyrXjJYBCnlDDSPppldflBDYAWQ+mvQa0f4yYNudpebPQOkM1WYFVjI0ijTavLx7
         2yjRzGlp5VXtkfMaJsGM7Aj0eot2xbS0KmwoUfOvd084IEQOpz/KVbaRmO0j2GDQ8rdf
         Fhq5Ye2dGeb8NbU52Wcd3AaTDOqFQXxIv+MGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=De/YPVJfANZHcQoM3xdk0dmtPOk60iDgsIGhB4FUjTk=;
        b=Dy+rq4B/OI9uVU/MgvYNYA6PKxqUEUXNtMljWR6ouQcylkFQPWsOPg+D3jKYL5V+0i
         f5Qt7y6WTxFjx5evFxgUwPdk12T8o/UfSIlx9+ksbkfEcq4c4et73R2r6bMMoGPHwJ8X
         9rgmq030RMPmP8ungxW/keI7HQXIzZ6hQRiCBO9tZO42R73OqhESkopS19eLCLGlGodA
         J8vrf+bSZzdCrbUC+3LMO3WdqAdB3CXrmsW6ttaJugTMI07MIn6LPmrGtyNkl1WPt+au
         kjZXFVXsuOp++BfN4kzj2BCbAXMDBmKmZq+Db/3zgVePWVuJ3rM5FOd4+u2DRtjrQ2CJ
         Mq4A==
X-Gm-Message-State: AJIora8kaBTPK0ebIHhESoUdduBwCbpk3lN1Va08euCA2CRbP2SAsZ7A
        QBPxnJnaYM/6MFSivTthf/zsGw==
X-Google-Smtp-Source: AGRyM1vd8xbQwzdh6Yfrn9olFj1kgatBeb5Z5OH+waypR66RExfMMuylbwLqj88HVaSjG5t5Sk4Ikg==
X-Received: by 2002:a17:90b:4b82:b0:1e6:7835:2f05 with SMTP id lr2-20020a17090b4b8200b001e678352f05mr33513390pjb.121.1655831794306;
        Tue, 21 Jun 2022 10:16:34 -0700 (PDT)
Received: from C02YVCJELVCG.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id mq17-20020a17090b381100b001ec71258838sm6393088pjb.27.2022.06.21.10.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 10:16:33 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Tue, 21 Jun 2022 13:16:24 -0400
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Andy Gospodarek <andrew.gospodarek@broadcom.com>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, toke@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next] samples/bpf: fixup some xdp progs to be able to
 support xdp multibuffer
Message-ID: <YrH86MxwX9VXnGbC@C02YVCJELVCG.dhcp.broadcom.net>
References: <20220617220738.3593-1-gospo@broadcom.com>
 <YrHxF3j5cqqVWE2y@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <YrHxF3j5cqqVWE2y@localhost.localdomain>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ecdd2f05e1f861b7"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000ecdd2f05e1f861b7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 21, 2022 at 06:25:59PM +0200, Lorenzo Bianconi wrote:
> > This changes the section name for the bpf program embedded in these
> > files to "xdp.frags" to allow the programs to be loaded on drivers that
> > are using an MTU greater than PAGE_SIZE.  Rather than directly accessing
> > the buffers, the packet data is now accessed via xdp helper functions to
> > provide an example for those who may need to write more complex
> > programs.
> > 
> > Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
> 
> Hi Andy,
> 
> Just 2 nit inline but the code is fine.

Thanks, Lorenzo.  I'll re-spin now.


> Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> > ---
> >  samples/bpf/xdp1_kern.c            | 13 ++++++++++---
> >  samples/bpf/xdp2_kern.c            | 13 ++++++++++---
> >  samples/bpf/xdp_tx_iptunnel_kern.c |  2 +-
> >  3 files changed, 21 insertions(+), 7 deletions(-)
> > 
> > diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
> > index f0c5d95084de..a798553fca3b 100644
> > --- a/samples/bpf/xdp1_kern.c
> > +++ b/samples/bpf/xdp1_kern.c
> > @@ -39,17 +39,24 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
> >  	return ip6h->nexthdr;
> >  }
> >  
> > -SEC("xdp1")
> > +#define XDPBUFSIZE	64
> > +SEC("xdp.frags")
> >  int xdp_prog1(struct xdp_md *ctx)
> >  {
> > -	void *data_end = (void *)(long)ctx->data_end;
> > -	void *data = (void *)(long)ctx->data;
> > +	__u8 pkt[XDPBUFSIZE] = {};
> > +	void *data_end = &pkt[XDPBUFSIZE-1];
> > +	void *data = pkt;
> >  	struct ethhdr *eth = data;
> >  	int rc = XDP_DROP;
> >  	long *value;
> >  	u16 h_proto;
> >  	u64 nh_off;
> >  	u32 ipproto;
> > +	int err;
> > +
> > +	err = bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt));
> > +	if (err < 0)
> > +		return rc;
> 
> I guess we do not need err here:
> 
> 	if (bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt)) < 0)
> 		return XDP_DROP;
> 
> >  
> >  	nh_off = sizeof(*eth);
> >  	if (data + nh_off > data_end)
> > diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
> > index d8a64ab077b0..1502ef820aed 100644
> > --- a/samples/bpf/xdp2_kern.c
> > +++ b/samples/bpf/xdp2_kern.c
> > @@ -55,17 +55,24 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
> >  	return ip6h->nexthdr;
> >  }
> >  
> > -SEC("xdp1")
> > +#define XDPBUFSIZE	64
> > +SEC("xdp.frags")
> >  int xdp_prog1(struct xdp_md *ctx)
> >  {
> > -	void *data_end = (void *)(long)ctx->data_end;
> > -	void *data = (void *)(long)ctx->data;
> > +	__u8 pkt[XDPBUFSIZE] = {};
> > +	void *data_end = &pkt[XDPBUFSIZE-1];
> > +	void *data = pkt;
> >  	struct ethhdr *eth = data;
> >  	int rc = XDP_DROP;
> >  	long *value;
> >  	u16 h_proto;
> >  	u64 nh_off;
> >  	u32 ipproto;
> > +	int err;
> > +
> > +	err = bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt));
> > +	if (err < 0)
> > +		return rc;
> 
> same here
> 
> >  
> >  	nh_off = sizeof(*eth);
> >  	if (data + nh_off > data_end)
> > diff --git a/samples/bpf/xdp_tx_iptunnel_kern.c b/samples/bpf/xdp_tx_iptunnel_kern.c
> > index 575d57e4b8d6..0e2bca3a3fff 100644
> > --- a/samples/bpf/xdp_tx_iptunnel_kern.c
> > +++ b/samples/bpf/xdp_tx_iptunnel_kern.c
> > @@ -212,7 +212,7 @@ static __always_inline int handle_ipv6(struct xdp_md *xdp)
> >  	return XDP_TX;
> >  }
> >  
> > -SEC("xdp_tx_iptunnel")
> > +SEC("xdp.frags")
> >  int _xdp_tx_iptunnel(struct xdp_md *xdp)
> >  {
> >  	void *data_end = (void *)(long)xdp->data_end;
> > -- 
> > 2.25.1
> > 
> 
> 



--000000000000ecdd2f05e1f861b7
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
E90b6DQq048oqwEJMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCAnmIlaP9uCu2ky
HfECSm3RJkXQJ6f4FKTHxyIsY5BRBjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMjA2MjExNzE2MzRaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAOEYweQUp/sKyWKbYxTJX1Iez6War48WR
RbJ6fjZqsmO9MM7pU7ZGEYsMAwFovRSGJubvJ90h1uXuL9qaa3C7nWZTzrneFtK3RYiFwQ+iplk1
fgkdRoszlYhhv6dREtlEmU9pClRsiXetRWz113NStB6k0z65M6RBXTb2Sjfj8HGknmjWsnofmYx3
/ZUkrPrYVCv7N2xip2B7YRW47+0Ob7b7mhkFKVreVYezmgb0g9n6V7wTkJngixKBgtVb/8OyKCVQ
u96PGGylNGf7ScgfwjgVtLFZUzJ+6FvKhN/HE1AfjNpBIRSJ5nGrpAxAT/+lbTD0tabmpFDfs1wf
S5hJZQ==
--000000000000ecdd2f05e1f861b7--
