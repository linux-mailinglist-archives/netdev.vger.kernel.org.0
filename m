Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2351397357
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhFAMhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhFAMhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 08:37:08 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B44C061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 05:35:27 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h16so4489500pjv.2
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 05:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=41NqeRY5GAaGSqfXDm4TTVN6QSSLf3DC8Uc5OhGspR8=;
        b=RUxlJNaWakhZd+NErUEu2fq2ZfFaOz1GoeopRYquTGjGBV69h2kRjAmWK1lOCUYhyP
         3c/MROYZr47rz31nJWM7flecGF0tLPBmbRDl33694s/ZATT6okaYGEj2LwUR+lJHMatc
         C6Md/Nb6dvsbX2qwI3GpQYClxBtkEclDNeCXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=41NqeRY5GAaGSqfXDm4TTVN6QSSLf3DC8Uc5OhGspR8=;
        b=eMW74vUMnxYgpdgIeTdhyvNZF2jhyftnS2ZFkDADsUIHdqQTrVFvGYV3I2HmcG0Xfa
         S3D+dEXZd9Pl2bdxuMVBK3eXUzpmqo/Ji/WTKFj/50DhDl51HO159qBxPYiTKnx2Gy9Z
         fzoht5YJI8wfKSTvwJl7O4bQpCjJEcrLZK0Wu02/kgqx40vFJ1A5vBCdoHU4oabh9cJZ
         G1l0VC56NuMa4cljiUFLlnvwdiYopKBPBqL5rP1yI4EYq//L5Npl9Olq4pm7W6I3NUXz
         KG3Tu9SFtDPVLiCj0fIeN344PjO4VL3qsatGWGx1j8ra5akONTQ02psATPwQ+wApWjDK
         mvNA==
X-Gm-Message-State: AOAM533ys9FyQmWyV6PSZ1GNIEmuiEGmgGeEhVZ0VJz+9N5whbxIL3nB
        STBzTU88oY8r+68zCY3rBnyuFXuC7iCx/CBA
X-Google-Smtp-Source: ABdhPJwvtG7V88flyIaIoGEPRbzBzlD7oZBidtjSAXRicjycCiKlVVRhdW/KgAUmuBLom8EOQy9Pxw==
X-Received: by 2002:a17:90a:ab90:: with SMTP id n16mr4703748pjq.223.1622550927017;
        Tue, 01 Jun 2021 05:35:27 -0700 (PDT)
Received: from builder ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id i2sm2239978pjj.25.2021.06.01.05.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 05:35:26 -0700 (PDT)
Date:   Tue, 1 Jun 2021 15:35:10 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH net-next v3 2/3] net/sched: act_vlan: No dump for unset
 priority
Message-ID: <20210601123510.GA3940@builder>
References: <20210530114052.16483-1-boris.sukholitko@broadcom.com>
 <20210530114052.16483-3-boris.sukholitko@broadcom.com>
 <20210531222136.26670598@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
In-Reply-To: <20210531222136.26670598@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a7bc1605c3b3934d"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000a7bc1605c3b3934d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jacub,

On Mon, May 31, 2021 at 10:21:36PM -0700, Jakub Kicinski wrote:
> On Sun, 30 May 2021 14:40:51 +0300 Boris Sukholitko wrote:
> > diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
> > index a108469c664f..ccd1acfa4c55 100644
> > --- a/net/sched/act_vlan.c
> > +++ b/net/sched/act_vlan.c
> > @@ -307,8 +307,8 @@ static int tcf_vlan_dump(struct sk_buff *skb, struct tc_action *a,
> >  	    (nla_put_u16(skb, TCA_VLAN_PUSH_VLAN_ID, p->tcfv_push_vid) ||
> >  	     nla_put_be16(skb, TCA_VLAN_PUSH_VLAN_PROTOCOL,
> >  			  p->tcfv_push_proto) ||
> > -	     (nla_put_u8(skb, TCA_VLAN_PUSH_VLAN_PRIORITY,
> > -					      p->tcfv_push_prio))))
> > +	     (p->tcfv_push_prio_exists &&
> > +	      nla_put_u8(skb, TCA_VLAN_PUSH_VLAN_PRIORITY, p->tcfv_push_prio))))
> >  		goto nla_put_failure;
> >  
> >  	if (p->tcfv_action == TCA_VLAN_ACT_PUSH_ETH) {
> > @@ -362,10 +362,19 @@ static int tcf_vlan_search(struct net *net, struct tc_action **a, u32 index)
> >  
> >  static size_t tcf_vlan_get_fill_size(const struct tc_action *act)
> >  {
> > -	return nla_total_size(sizeof(struct tc_vlan))
> > +	struct tcf_vlan *v = to_vlan(act);
> > +	struct tcf_vlan_params *p;
> > +	size_t ret = nla_total_size(sizeof(struct tc_vlan))
> >  		+ nla_total_size(sizeof(u16)) /* TCA_VLAN_PUSH_VLAN_ID */
> > -		+ nla_total_size(sizeof(u16)) /* TCA_VLAN_PUSH_VLAN_PROTOCOL */
> > -		+ nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
> > +		+ nla_total_size(sizeof(u16)); /* TCA_VLAN_PUSH_VLAN_PROTOCOL */
> > +
> > +	spin_lock_bh(&v->tcf_lock);
> > +	p = rcu_dereference_protected(v->vlan_p, lockdep_is_held(&v->tcf_lock));
> > +	if (p->tcfv_push_prio_exists)
> > +		ret += nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
> > +	spin_unlock_bh(&v->tcf_lock);
> 
> This jumps out a little bit - if we need to take this lock to inspect
> tcf_vlan_params, then I infer its value may change. And if it may
> change what guarantees it doesn't change between calculating the skb
> length and dumping?
> 
> It's common practice to calculate the max skb len required when
> attributes are this small.
> 

I believe you are right.

I've just sent out v4 of the patch with tcf_vlan_get_fill_size change
reverted.

Thanks,
Boris.

--000000000000a7bc1605c3b3934d
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
XzCCBVgwggRAoAMCAQICDDSzinKpvcPTN4ZIJTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIwNzMwMDRaFw0yMjA5MDUwNzM3NTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGTAXBgNVBAMTEEJvcmlzIFN1a2hvbGl0a28xLDAqBgkqhkiG
9w0BCQEWHWJvcmlzLnN1a2hvbGl0a29AYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAy/C7bjpxs+95egWV8sWrK9KO0SQi6Nxu14tJBgP+MOK5tvokizPFHoiXTymZ
7ClfnmbcqT4PzWgI3thyfk64bgUo1nQkCTApn7ov3IRsWjmHExLSNoJ/siUHagO6BPAk4JSycrj5
9tC9sL4FnIAbAHmOSILCyGyyaBAcmiyH/3toYqXyjJkK+vbWQSTxk2NlqJLIN/ypLJ1pYffVZGUs
52g1hlQtHhgLIznB1Qx3Fop3nOUk8nNpQLON/aM8K5sl18964c7aXh7YZnalUQv3md4p2rAQQqIR
rZ8HBc7YjlZynwOnZl1NrK4cP5aM9lMkbfRGIUitHTIhoDYp8IZ1dwIDAQABo4IB3jCCAdowDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAoBgNVHREEITAfgR1ib3Jpcy5zdWtob2xpdGtvQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUtBmGs9S4
t1FcFSfkrP2LKQQwBKMwDQYJKoZIhvcNAQELBQADggEBAJMAjVBkRmr1lvVvEjMaLfvMhwGpUfh6
CMZsKICyz/ZZmvTmIZNwy+7b9r6gjLCV4tP63tz4U72X9qJwfzldAlYLYWIq9e/DKDjwJRYlzN8H
979QJ0DHPSJ9EpvSKXob7Ci/FMkTfq1eOLjkPRF72mn8KPbHjeN3VVcn7oTe5IdIXaaZTryjM5Ud
bR7s0ZZh6mOhJtqk3k1L1DbDTVB4tOZXZHRDghEGaQSnwU/qxCNlvQ52fImLFVwXKPnw6+9dUvFR
ORaZ1pZbapCGbs/4QLplv8UaBmpFfK6MW/44zcsDbtCFfgIP3fEJBByIREhvRC5mtlRtdM+SSjgS
ZiNfUggxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgw0
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIB9IUnUc2ErZv/gd
mwlvLi7uCuIEBydk3+q+ZlxF7wZ6MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDYwMTEyMzUyN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDF7Zb+MQJzPqfvgMpIgt97xMOIxgYnLP5T
AI8rf3eqcG4C8wqtaxtBEIIvHMllRfxfLGc6no1A1+cI2TwcPI54RrbZf0263wmPp3OdbyrQKl82
N80pT2FTWbtNg+65B+QH1RqnoAh2NNO8kBpHVE8zV8GuaigGz5C+jYUFcr97+lNZU34536B8nLIu
BIijI1MzH7QE3vBLY8XN8Aju7EndNdv5MvNUGTBE7J+iIiBOvuK5crMAMXKSXzJpWQ1MjN6KxmSG
2naJEXKFtIOtNvbuQo9Yuttu7s76WC2K7Pe7/ukOeGHOC9ib89Y0BLVrCPTU62IVpzhdMDjF91t2
402M
--000000000000a7bc1605c3b3934d--
