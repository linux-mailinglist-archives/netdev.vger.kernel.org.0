Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D55C075F
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 16:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfI0O0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 10:26:44 -0400
Received: from mout.web.de ([212.227.15.4]:36607 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbfI0O0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 10:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569594390;
        bh=tn9PVg9E/PLEvgmiwwqgXnvlHelynp+BqoPiHXcL2SU=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=YgsDhm59dKhKQFr9VUp8nA2ABSk9zlGnq6I8T6IygMz9VhSub5qSfRhnPBi00p4R8
         S9zgQL1vGg0ZCmF+cHxCU4wZG0zax1EaRA85Yv/YLfKCZRxYk4jeIAzbySK/Fq2weo
         nDklWKToFpnQXJk/F7/EsHHwfSW2zQV8Lolk+KsQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.191.8]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LpwMZ-1hhntp0cX1-00fg63; Fri, 27
 Sep 2019 16:26:30 +0200
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen A McCamant <smccaman@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Frederik Lotter <frederik.lotter@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190925182405.31287-1-navid.emamdoost@gmail.com>
Subject: Re: [PATCH] nfp: flower: prevent memory leak in
 nfp_flower_spawn_phy_reprs
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <95ee54a0-a5ff-a9f0-0d87-471e0f1f790c@web.de>
Date:   Fri, 27 Sep 2019 16:26:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190925182405.31287-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:ft+zKUE+sK3aNCGLB5RhDOFVPiCMUg/6fPQMt+VV2vC3V4knNZj
 zQ15PFAHai252MmMsBIbyPOi3m8EWx57pgrHO0lXSu9UW9SLHPsxRLxwkQp7op5kP0cF/1h
 BkUTrfbv0wek2Lhc5bw2bmPrhtOlhV+RJpd4YVghBt3A6yKnrQAbkv4UjWplvstmPkOXzsA
 ZccEoYT+nvxbooygis9xQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Piojxsa/rho=:xgrVQyOodkPmvqUNXG8FY2
 SIhjE0mSyhkBmzbUdZ3/Ugy+XtkqluRY3IlQoOas+gUn9oN19W3YMdFjluYSabW/e8nVbY5W/
 68FuzO720GcmMSStt3qWTqGp24NKGJvWi8K/6lOTcQ0HuMXeHyLkW0/fJfmKOe1/KTdSkNHIo
 5f8T4a++NqYN18wnsX4QRP7HJy+tU0szkMrWk8iKaZ6FlH+IRW7nkZiSzhRc3F5Qli44Dx75r
 1ybwHwmI8NMA67m6QKYTIICG+qIp6kieRqaFE9w1A3N6KxInpX1kDjLTWKibaLFXZqsRCrfkD
 ty/R8Q83YQrjLrIA8SZCsc14Ke/Vw20H/VOB3uhJByjKMRpO6Yj3HHrsbmi1sHddmi6Tnv2Wn
 i+jxoTQvEgTX/eIjOziqDx2LVEjDML56Hdq+1Y+p6bZYkrgJYjIUB2yLCSrvvEjrCpI01jA0Y
 k9VoFkFNUZX5hzTmauFxS2p75iuEbBzcWk3RwO6R2KbTCzExML8Exi0KEJ/bmnMtOWyJdBIBr
 5KNPVYCPXPT9xhkM77xEEIr3egF+LjIE2IHAMRlRSTEiuHULbR00+ga5V2WWT0TFbHi9QCr9J
 +6JA59hMtxxpbc8bVXX5WPoVvOuAApzMHw5DEs5hf69Q2Z/V2N6c4Z8W2yLD7JPMaMBdNN3zA
 8GAftTnR69f8fRSPIEoGZFTQgjKfshdVum7vb/NYOv5A1cvieQH13NLyMgcYh8fBZDu79IZm8
 a3WmPvWOk/8MSl4gbKarX8DQg8EKkCMGeKdvmhcrFwYovdfURhYFyciUTjEriDQDMvY26ZKi7
 WH3oJnErubdNvu9vJo1MZsNHJCaZhPA1srhbAH2iWTDpczvVrIRoCdIpwBTRLUUHcwVQKNPJb
 MFrZnlMg6ojDbvNmUUZt4FU+9BQD+18dQSngYNN1jMiKAzG62/DsvW2lEFvgTqtHP+/g7efW9
 Zmy1ZrtdNDGpE9liHTr6L6+47fKToPJUsgBoQu16y6FQenvmM+iXiJ1LJkYnA7QkeVF7aQbki
 HZMAA4cLO7H0c6hUWQwGmGSGnDSxW/WGcuasZtesPxT8DgK3NSK0gBig4fY9FCFdmfYRmuN5P
 xAFD4kZVQi6sBCA0BziIMP/XBQGci4RAsd9xYD88/pgjWTVdvHNASa0Oe2T61TtGusPQWiYfa
 2XjQVz3FCQp8oTOVt2HPRsUew2VPTWy0MMLCyauKnEw4BuyO6xDC3GF3sE4jKHWHLiIv1f2k2
 Ok53WoL+CRVphS3XptQn3x86T4jwegy60cQHmI22jHkCVxj45gWCWLyb1prA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In nfp_flower_spawn_phy_reprs, in the for loop over eth_tbl if any of
> intermediate allocations or initializations fail memory is leaked.
> requiered releases are added.

I suggest to improve also this change description.


> @@ -542,6 +545,7 @@ nfp_flower_spawn_phy_reprs(struct nfp_app *app, struct nfp_flower_priv *priv)
>  		err = nfp_repr_init(app, repr,
>  				    cmsg_port_id, port, priv->nn->dp.netdev);
>  		if (err) {
> +			kfree(repr_priv);
>  			nfp_port_free(port);
>  			nfp_repr_free(repr);
>  			goto err_reprs_clean;

How do you think about to move common exception handling code
to the end of this function implementation by adding jump targets?

Regards,
Markus
