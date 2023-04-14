Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1F66E26BD
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 17:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjDNPVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 11:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjDNPVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 11:21:07 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6AC2737
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 08:21:05 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id c3so19560403pjg.1
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 08:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1681485665; x=1684077665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ddp7zbJsFI2LULslaE966i7WbVS+RCt8W11GayM71AU=;
        b=ZmorWwNEaxulATkxJ67e0yqKfnq7W6DO6PL9cQLNHhBHpkSP959ZBThxjSVHZLXjbT
         9pvd5KDqMvKp5drbO4k87SZOVOqJO+JkWLtPUdYF/FWkJsaAs1rABjqI9DKcwFxLOgmy
         5uElK1mjmJTDlgcqN2weToGvhTPcPwd577j/z0r6RN2RLt7Mw61TlxD8dxnuRzjf+w04
         TiFzdHpE5Ap3u9Q7fcmL8OYxXd/xUaXjcPGToqX3V5SIcVRyWaoVbmmwSMYge2kN0wPa
         MY2H+kozK2ocUYpXjOUzB6tWp25r1h704s4X0J7lDdEcWSxI7kahYZvLPqzg+/iQnuKT
         KtNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681485665; x=1684077665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ddp7zbJsFI2LULslaE966i7WbVS+RCt8W11GayM71AU=;
        b=VtqJb3dpP2lVb7MQkUV1KktBWVzdf7y2Om1gbhKZEpjM+rGJOHf66N1gjF1YTfVnFW
         nlDpC4J/Pgj7vQxWTF2V9f0Abhg4ufVGRzdVqyc1gKclTDXFco1KhFkzcZNaZuNhD+U2
         IQvSgTUr/mX2MDqkmK1iUCYnkdH+AOUUraPUG5IaSU8uBdMJ5ECz/CJPVohtif1aFcq+
         e51PybzoqD3k6Il2akAwFbB4jdqgpH6MzfBdjP/5ISAuLI69AlQ1sgXHGh1KcUU5qTU1
         QE9bbqoJp6Rg0yFV8anvUVo9DVYgwctz7ScRFCNRT8+zI3dtg47Qd93SqKNFOCSE4f/I
         9Vaw==
X-Gm-Message-State: AAQBX9ctzugeThGa/agH+5shlTmeIQJKL2+gzntvaZhrrauTVHxvavQ0
        bxNYE+/ugkstv4Vp+/hXJD5ykWImOOzi3wXSFfKdFw==
X-Google-Smtp-Source: AKy350YYT8bQ0YQbB30n0x1yBScp0xZf3ebMR80x6XTijxlQvanfXSh3PXmOgtfkJfqIIm/HFNERBA==
X-Received: by 2002:a17:902:e812:b0:19f:8ad5:4331 with SMTP id u18-20020a170902e81200b0019f8ad54331mr3653451plg.38.1681485665336;
        Fri, 14 Apr 2023 08:21:05 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id gi1-20020a17090b110100b00246ba2b48f3sm8322462pjb.3.2023.04.14.08.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 08:21:05 -0700 (PDT)
Date:   Fri, 14 Apr 2023 08:21:03 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Lars Ekman <uablrek@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: iproute2 bug in json output for encap
Message-ID: <20230414082103.1b7c0d82@hermes.local>
In-Reply-To: <e3bfc8e6-5522-4e65-373e-976388533765@gmail.com>
References: <e3bfc8e6-5522-4e65-373e-976388533765@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 10:29:15 +0200
Lars Ekman <uablrek@gmail.com> wrote:

> The destination is lost in json printout and replaced by the encap=20
> destination. The destination can even be ipv6 for an ipv4 route.
>=20
> Example:
>=20
> vm-002 ~ # ip route add 10.0.0.0/24 proto 5 dev ip6tnl6 encap ip6 dst=20
> fd00::192.168.2.221
> vm-002 ~ # ip route show proto 5
> 10.0.0.0/24=C2=A0 encap ip6 id 0 src :: dst fd00::c0a8:2dd hoplimit 0 tc =
0=20
> dev ip6tnl6 scope link
> vm-002 ~ # ip -j route show proto 5 | jq
> [
>  =C2=A0 {
>  =C2=A0=C2=A0=C2=A0 "dst": "fd00::c0a8:2dd",
>  =C2=A0=C2=A0=C2=A0 "encap": "ip6",
>  =C2=A0=C2=A0=C2=A0 "id": 0,
>  =C2=A0=C2=A0=C2=A0 "src": "::",
>  =C2=A0=C2=A0=C2=A0 "hoplimit": 0,
>  =C2=A0=C2=A0=C2=A0 "tc": 0,
>  =C2=A0=C2=A0=C2=A0 "dev": "ip6tnl6",
>  =C2=A0=C2=A0=C2=A0 "scope": "link",
>  =C2=A0=C2=A0=C2=A0 "flags": []
>  =C2=A0 }
> ]
>=20

Both JSON and regular output show the same address which is coming from
the kernel.  I.e not a JSON problem. Also, you don't need to use jq
ip has -p flag to pretty print.

I can not reproduce this with current kernel and iproute2.
# ip route add 192.168.11.0/24 proto 5 dev dummy0 encap ip6 dst fd00::192.1=
68.2.221

# ip route show proto 5
192.168.11.0/24  encap ip6 id 0 src :: dst fd00::c0a8:2dd hoplimit 0 tc 0 d=
ev dummy0 scope link=20

# ip -j -p route show proto 5
[ {
        "dst": "192.168.11.0/24",
        "encap": "ip6",
        "id": 0,
        "src": "::",
        "dst": "fd00::c0a8:2dd",
        "hoplimit": 0,
        "tc": 0,
        "dev": "dummy0",
        "scope": "link",
        "flags": [ ]
    } ]


# ip -V
ip utility, iproute2-6.1.0, libbpf 1.1.0
# uname -r
6.1.0-7-amd64


