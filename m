Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF846C06FF
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 16:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfI0OG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 10:06:56 -0400
Received: from mout.web.de ([212.227.15.4]:60281 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfI0OGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 10:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569593202;
        bh=nv4VE+Hbl85HkmHRkfiuhBbAYfzLvV9VGG8OPZN4w70=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=PYa6H1N9q2C1vvlXyP199nW+PdFcGJHhSg29sTX3w+Hi+8GJpQ5F4nvC9MZ18VdGT
         P4wHzhHsdgCQYY6NmBhJOp7xoWoMxdnKz2dwphIz3uZBtoi6TujwHHAWaZ7iMpU19u
         QMYGBWsGo1yd+GSHH6PmnTcov1BM6LDWdu9rrsUk=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.191.8]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lwq0e-1i7U6s26jA-016T4r; Fri, 27
 Sep 2019 16:06:42 +0200
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen A McCamant <smccaman@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Frederik Lotter <frederik.lotter@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190925190512.3404-1-navid.emamdoost@gmail.com>
Subject: Re: [PATCH] nfp: flower: fix memory leak in
 nfp_flower_spawn_vnic_reprs
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <e20e4ea4-72c8-2e2e-1745-309fc6f6a57c@web.de>
Date:   Fri, 27 Sep 2019 16:06:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190925190512.3404-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:87XX0FAUxgZ3ci/9ivhTH7PpNtdW6DCt86TFjJz9H4rtXgXyzLb
 q+NpTfs4SNUz9t1hB3bX/M+YDAWOirKFC1N+76qOYpHUymJWT/9aY9Rlh2Rmbolh/xFMwgC
 EHKVnxmOKBSwZb0n2lxZGGjRvpPhjJQrMrwyxTFdNJkyYhIXyXRoRwxryev54i05XDGIHs8
 PfVZzjgmwoLZvg7DVjPYQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gWcPJBtUSk8=:L65XnfIzm37/GoIgcGRJqo
 VDN54wQ/DiUytb+vz7ee3Q31WLf97SAt34EEN16oaCYyhUVUsxlX6jQADU1aRF/1xn8XwNEBx
 ePXO314VNOFu3tNKg8NhAlEdsEvyl/Ja9i6l1uLth3sVJnrlFXKeH36jW+OA2ViGlxKSCBSyw
 gm4EQy3xbxb/WALA9Hyg61/kTpY0P6rQ+4tY/p672RpCU6L24340eoOLcM0demFGrWkS8t9C9
 S5OjUWUZQde1hYD7fj7t08zJ2oY4HsPtsPlLKj5ZArquhQb2UZbhYjpPdtDjalpHNRkvheDb1
 u87lzH4VdqqWc1kW84QQS1q6xOchZkDBj0g5sFud2ZLkcAa3DDL4FtpfmEybmO8nD/71bYyVK
 9BPIR+Hqiu6SqdyqN9LU2eGsJ3Mp97oxYxTJXxNOAewRxw719/EIY7tyhIvOMreuyQGDn0IUF
 CmkNgyxrFv5LKrugcf/ZnX9CEGqaLau9zzWEwX+eFsP34MAHC8N0uYJj/xKCZYHJpWoHMO+w2
 acDQ0IGRUDlWfNTA0GAEcxgs/l5PCVNSc2uVhzSA5Zp1Dr0M5afjUiKgMUVT9opb0M+cIvL9p
 lMvlatGcmsOGB8n7DnKx9xq6h90VmAubJuh33zmS8KkyYXm9SgMsMiMB5hwPUYnQAWG4SocbJ
 HIiuPVH3v7ie0S6y5ncBREixp+0GCMUOAEjH+nFA0vaXLyouaVKeuEqctNYuo2ldoqgi0uhA7
 MHmM7QACyxZrb1cuEQuR9NZdAK4dd9xJ3mt93JRgfdPNKRWqYNkzOA99X3H94aayGCJkWVBCe
 P8XRZKJx9Sii4vgCzlJUOkR56Z3/36Z284FBSIYIt91HL6CIz4miswB6Zre3aAxwLLeIj3rmn
 zG9SIv4mAQuSOU4C1ybNMMGHsHWrSq/sGo+9HQVtzptd37nf0C1dYsROsGEltPykpTlqCc/gC
 T95Bd6VcbTcIygtmXlDeP2HIbh/g6f+0Nb3fKR/y+kQIPCW9od+joP6gO8QlV61l+HEF+qoOd
 xF1II0gdiqa8dmobJ7orfIvgtUue7GcogPmvovnM3tcb/pCZaKX3cEnbV/dkGAMUvcmOeG31d
 1f6jp0hyjN+oSE7DIIXhbXnofsv6YJ6IWSEeLFrJwmaMVb4qfbU5Mivpx7dW8IMw00vemKxDq
 lJkx/1utYea9peBbLIEj414SmW6SnMLgZ4jdKk8RysBjqHhZsu+M0INz4pi6Qhp7MXjdqBY7Z
 tNEeD9X3thZLFEGWej9NXk0sTKaZ4wQiwt+as0+N40LUwzKQcRJU+tXdyjRE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -433,6 +435,7 @@ nfp_flower_spawn_vnic_reprs(struct nfp_app *app,
>  		err = nfp_repr_init(app, repr,
>  				    port_id, port, priv->nn->dp.netdev);
>  		if (err) {
> +			kfree(repr_priv);
>  			nfp_port_free(port);
>  			nfp_repr_free(repr);
>  			goto err_reprs_clean;

How do you think about to move common exception handling code
to the end of this function implementation by using another jump target?

Regards,
Markus
