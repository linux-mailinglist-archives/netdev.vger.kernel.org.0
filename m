Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55FCC56F3B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 19:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfFZRDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 13:03:01 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53846 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfFZRDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 13:03:01 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so2867325wmj.3
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 10:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:in-reply-to:references:mime-version:content-transfer-encoding
         :subject:to:cc:from:message-id;
        bh=MIGo0bh56XRim7vv4SPRVFHU7SvXnQXX32TPmrk9QaY=;
        b=Uc2xLmTiPeXRim/6AfwXuca6kDm/w8c9S3H5gE14zpXdecoBV07st2+YmRK90cg7Er
         dzMp2bkTg072558Zjra4xF0vODH1CgvxYc2LzSjS9/6rI9ErKbpS2tVMJ6sol/tYudPE
         7M2lSpKdqBUYEFytDNN1wbsmq+vjwkVdcEeYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=MIGo0bh56XRim7vv4SPRVFHU7SvXnQXX32TPmrk9QaY=;
        b=D+ZK+66P5WvIKili3zZw/MYGZ7s0D/qTwhzLSoIMa2nFAFrVS5CMB86VGvmp3tZHOP
         UK24GPdvlHSbjeJBbGq8fekTtJbjuqZI1paebUtAy6i0gmU2J1eZS8/714jCNCXRnklK
         UMcBUEa9788WMS9ORT0LtIoD+WsAK3kAoJhq5KhulxGgRI+s2MYyJYlaW9MDNDcdAqyc
         WZXYVWTWDl68HRY30Gmo7p7chZ0adfGUTtKWWGCALdjNdIG4srat6oVJh67ByIs8CMn4
         RiQcpX6wrntsX/kefB2eguS4sjzkUqcK77Rum3xluT9YPg6WToY9EGpRQpzfCjOD8bAc
         d+sg==
X-Gm-Message-State: APjAAAUOADA/9INRq/nz0mKpAQrtDjnfGy3SFbKoSg0A58LuMrPP8Uhy
        DadHlLkUEHyaTqhSF52LuzJmTw==
X-Google-Smtp-Source: APXvYqxYkNAptQ7ewdZvxGYE3QoI9O44a6A9yPrrJQLW3XLS/qJQzmfkBc+caeGNFfNQQH8cWN6yPg==
X-Received: by 2002:a1c:968c:: with SMTP id y134mr41480wmd.122.1561568578777;
        Wed, 26 Jun 2019 10:02:58 -0700 (PDT)
Received: from localhost ([149.62.204.238])
        by smtp.gmail.com with ESMTPSA id t14sm13729755wrr.33.2019.06.26.10.02.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 10:02:58 -0700 (PDT)
Date:   Wed, 26 Jun 2019 20:02:54 +0300
In-Reply-To: <92B812B3-C5FB-452B-809A-1367349DB29A@cumulusnetworks.com>
References: <20190626155615.16639-1-nikolay@cumulusnetworks.com> <20190626155615.16639-4-nikolay@cumulusnetworks.com> <20190626191835.1e306147@eyal-ubuntu> <92B812B3-C5FB-452B-809A-1367349DB29A@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next v2 3/4] net: sched: em_ipt: keep the user-specified nfproto and use it
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, jhs@mojatatu.com
From:   nikolay@cumulusnetworks.com
Message-ID: <80910ECA-ACA0-4157-BA66-6EACCFA9D8DB@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 June 2019 19:33:48 EEST, nikolay@cumulusnetworks=2Ecom wrote:
>On 26 June 2019 19:18:35 EEST, Eyal Birger <eyal=2Ebirger@gmail=2Ecom>
>wrote:
>>Hi Nik,
>>
>>On Wed, 26 Jun 2019 18:56:14 +0300
>>Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom> wrote:
>>
>>> For NFPROTO_UNSPEC xt_matches there's no way to restrict the
>matching
>>> to a specific family, in order to do so we record the user-specified
>>> family and later enforce it while doing the match=2E
>>>=20
>>> v2: adjust changes to missing patch, was patch 04 in v1
>>>=20
>>> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom>
>>> ---
>>>  net/sched/em_ipt=2Ec | 17 +++++++++++++++--
>>>  1 file changed, 15 insertions(+), 2 deletions(-)
>>>=20
>>=2E=2Esnip=2E=2E
>>> @@ -182,8 +195,8 @@ static int em_ipt_match(struct sk_buff *skb,
>>> struct tcf_ematch *em, const struct em_ipt_match *im =3D (const void
>>> *)em->data; struct xt_action_param acpar =3D {};
>>>  	struct net_device *indev =3D NULL;
>>> -	u8 nfproto =3D im->match->family;
>>>  	struct nf_hook_state state;
>>> +	u8 nfproto =3D im->nfproto;
>>
>>Maybe I'm missing something now - but it's not really clear to me now
>>why keeping im->nfproto would be useful:
>>
>>If NFPROTO_UNSPEC was provided by userspace then the actual nfproto
>>used
>>will be taken from the packet, and if NFPROTO_IPV4/IPV6 was specified
>>from userspace then it will equal im->match->family=2E
>>
>>Is there any case where the resulting nfproto would differ as a result
>>of this patch?
>>
>>Otherwise the patchset looks excellent to me=2E
>>
>>Thanks!
>>Eyal=2E
>
>Hi,
>It's needed to limit the match only to the user-specified family
>for unspec xt matches=2E The problem is otherwise im->match->family
>stays at nfproto_unspec regardless of the user choice=2E
>
>Thanks for reviewing the set=2E=20
>
>Cheers,
>  Nik

Hm, while that is true, thinking more about it - mixing the user proto and=
 the real proto
could be problematic since we no longer enforce them to be equal, but we c=
heck
the network header len based on the packet only and we can end up checking=
 v4
len and parsing it as nfproto v6=2E=20

I'll spin v3 with unspec only and we can restrict it later if needed=2E=20





