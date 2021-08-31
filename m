Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177EC3FC6E9
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 14:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhHaMFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 08:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhHaMFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 08:05:52 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A22C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 05:04:56 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id t42so14734626pfg.12
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 05:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=VgAE/mVE5d8Ee1jGsCmET6TVZtWLz1W3PZtvV3FgSi8=;
        b=ZYiuOFxNwVPQo3J5mTYd8kGNkOJrQv0aFOmv95ji73ae1AY0dxkseJhBN01qKTLg+h
         0j3Bavrum9UqVcW8KEvQ3Jg+N3J4dcVe8KMFlw9j+m4Zk5Q9tjVI4D1pElryBEJaITZs
         W+R+he+lAERGyLWyhqBu1cdo59QmLEB6E09Ro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=VgAE/mVE5d8Ee1jGsCmET6TVZtWLz1W3PZtvV3FgSi8=;
        b=HQ13p03w6Vu8fvnOOkLKLcGzAaiRMj+1RDt9Vh/FiK04qI8QZ0JSm8MN8kxbQLEuS7
         goEi7E8VZ5+OuRTNnKs2vsU6XRmgJVwLW0mdkolzGVPayW1M8FBPepfohvuIMJSXx98a
         MOG1pRJeB+Ilaufv0BOEIQtP1lDysHIby2b/xw2aOU0g8v4Ielba/ZbcaQ6LUpkUPn26
         4IeE5E1U7A7dYUzMlwXMcs2oN6Xz3NqdjYR3GqaKLEqu+3IZKFN8kasSu/gJRO88U6I6
         okPtkuMLSR30JQ5fyAyR/lRrWgfmqV9vMXB8WKrTdhcbRStyepc/5pakBO0hHf1unHBv
         XvCg==
X-Gm-Message-State: AOAM533e3m6VbBJqu/YGa2JdoX6lWaRk+b4x+knfYeuVya8tMoAYzyKD
        99HKjqNlVPKG9CCpNoOWpKjRtQ==
X-Google-Smtp-Source: ABdhPJwIZTG4w+SdO6YcuTLDP07bvsA5hwGa2tQMvYLInerpsdxUUHvs5GbMbnpRi9iqa/zf/J53Dw==
X-Received: by 2002:aa7:8014:0:b029:3cd:b6f3:5dd6 with SMTP id j20-20020aa780140000b02903cdb6f35dd6mr28156590pfi.39.1630411495827;
        Tue, 31 Aug 2021 05:04:55 -0700 (PDT)
Received: from noodle ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id k189sm7270695pfd.76.2021.08.31.05.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 05:04:54 -0700 (PDT)
Date:   Tue, 31 Aug 2021 15:04:40 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        tom Herbert <tom@sipanda.io>,
        Felipe Magno de Almeida <felipe@expertise.dev>,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next] net/sched: cls_flower: Add orig_ethtype
Message-ID: <20210831120440.GA4641@noodle>
References: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
 <b05f2736-fa76-4071-3d52-92ac765ca405@mojatatu.com>
MIME-Version: 1.0
In-Reply-To: <b05f2736-fa76-4071-3d52-92ac765ca405@mojatatu.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001217dd05cad9c213"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000001217dd05cad9c213
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jamal,

On Mon, Aug 30, 2021 at 09:48:38PM -0400, Jamal Hadi Salim wrote:
> On 2021-08-30 4:08 a.m., Boris Sukholitko wrote:
> > The following flower filter fails to match packets:
> > 
> > tc filter add dev eth0 ingress protocol 0x8864 flower \
> >      action simple sdata hi64
> > 
> > The protocol 0x8864 (ETH_P_PPP_SES) is a tunnel protocol. As such, it is
> > being dissected by __skb_flow_dissect and it's internal protocol is
> > being set as key->basic.n_proto. IOW, the existence of ETH_P_PPP_SES
> > tunnel is transparent to the callers of __skb_flow_dissect.
> > 
> > OTOH, in the filters above, cls_flower configures its key->basic.n_proto
> > to the ETH_P_PPP_SES value configured by the user. Matching on this key
> > fails because of __skb_flow_dissect "transparency" mentioned above.
> > 
> > Therefore there is no way currently to match on such packets using
> > flower.
> > 
> > To fix the issue add new orig_ethtype key to the flower along with the
> > necessary changes to the flow dissector etc.
> > 
> > To filter the ETH_P_PPP_SES packets the command becomes:
> > 
> > tc filter add dev eth0 ingress flower orig_ethtype 0x8864 \
> >      action simple sdata hi64
> 
> Where's "protocol" on the above command line is. Probably a typo?

There is no need for protocol there. We intend to match on the tunnel
protocol existence only, disregarding its contents. Therefore
orig_ethtype key is sufficient.

> 
> The main culprit is clearly the flow dissector parsing. I am not sure
> if in general flowdisc to deal with deeper hierarchies/tunnels
> without constantly adding a lot more hacks. Imagine if you had an
> ethernet packet with double vlan tags and encapsulating a pppoe packet
> (i.e 3 or more layers of ethernet) - that would be a nightmare.

Of course there is no limit to our imagination :) However I would argue
that in the RealWorld(tm) the number of such nesting cases is
neglectable.

The evidence is that TC and flower are being actively used. Double VLAN
tags configurations notwithstading. IMHO, the fact that I've been
unlucky to hit this tunnel corner case does not mean that there is a
design problem with the flower.

AFAICS, the current meaning for the protocol field in TC is:

match the innermost layer 2 type through the tunnels that the kernel
knows about.

And it seems to me that this semantic is perfectly fine and does not
require fixing. Maybe be we need to mention it in the docs...

> IMO, your approach is adding yet another bandaid.

Could you please elaborate why do you see this approach as a bandaid? 

The patch in question adds another key to the other ~50 that exists in the
flower currently. Two more similar keys will be done for single and
double VLAN case. As a result, my users will gain the ability to match
packets that are impossible to match right now.

In difference with the TC protocol field, orig_ethtype answers the
question:

what is the original eth type of the packet, independent of the further
kernel processing.

IMHO, the above definition is also quite exact and has the right to
exist because we do not have such ability in the current kernel.

> 
> Would it make sense for the setting of the
> skb_key.basic.n_proto  to be from tp->protocol for
> your specific case in classify().
> 
> Which means your original setup:
>  tc filter add dev eth0 ingress protocol 0x8864 flower \
>      action simple sdata hi64
> 
> should continue to work if i am not mistaken. Vlans would
> continue to be a speacial case.
> 
> I dont know what that would break though...
> 

I think right off the bat, it will break the following user
configuration (untested!):

tc filter add dev eth0 ingress protocol ipv4 flower \
      action simple sdata hi64

Currently, the above rule matches ipv4 packets encapsulated in
ETH_P_PPP_SES protocol. The special casing will break it.

Thanks,
Boris.

> cheers,
> jamal

--0000000000001217dd05cad9c213
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBGvw0I+Cxd8GxUR
/10eaDaBsIezqXDP7MgmO24i0YTCMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDgzMTEyMDQ1NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBa98IvIOkEwJgvxc+gM0ny84jyaBi6KJf4
reK03nD4OU82K4W8BQGfS6eJG1zSX2jcG+Du0o0QkF6wUc9+OL02V0uGhFQlritP8SdbZF2UwfSz
Id0djT+fXo1JYUIaUmFoEz0YsixFh/AWUN1W3xJZNaB4Yu0MfzvnEEIWZVCncFU8K0IRa7kQBM+0
LwaeFPCYB8glojabtmPvcFRI0YSD0Qz/AuPvbvETFKgfo5tZqJfhqz6jIl76pMtumAIvAwaXmlJy
tCYweL6U2CIUhy3jPGymSyE3OvXmSzKP6105psLCGZ0TphhhtPPGyXRA9EDoxg38F8QTbLd9zr3p
UZ0v
--0000000000001217dd05cad9c213--
