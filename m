Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B1A56EF2
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfFZQis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:38:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43924 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfFZQir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:38:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so3478880wru.10
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 09:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:in-reply-to:references:mime-version:content-transfer-encoding
         :subject:to:cc:from:message-id;
        bh=k39fs1C43DT8/yjca+Mc4pg8x/tOvrIPADLDG2JNYOo=;
        b=D7OPtAJBXWEFGoQNNaq1LPJ7a3IPY2SvtHHQGYrnrEhvwbWrkHz8nCVx2g3psJtfbf
         xOnX9cc8HHcgbbMYzJvwC1OjKbHolJLA9KiBoc+wAI69JUMLIj9HVlnhBSDK66f+SEUL
         eKidVb0w0Anl5mdcOl3TCORpjA/C09l0w79Rw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=k39fs1C43DT8/yjca+Mc4pg8x/tOvrIPADLDG2JNYOo=;
        b=RI1r7rcZTyut+TgQp3KhlpAY04X2Rb96QmI0WoWMWXqjOYzPROc2SyldvDO19e200I
         MUKOl88Ie4/OZG3GHdKbi5OThpTlJQAm71JCwVRHQ8aLHZ8lAHKBSVL0cJfeIT1G6Y9o
         0h8IIYgOF+xAajAaZ2YIqlirLNyoo9EK2iTZUhjmndBmiY/TzWBXfqxpYSYmQTXPHKh6
         hHCdGiflEK/IQr/xYlSDdQPMknGRTSXZbfDtV29/5y7KPB7sC4qnD1WdYHKUd7PdEfAc
         7DwhQIucLpFyFhsJe/lWXXL5iom1CRpEDwBARdoiX3xAVo10mHv53Zlf/0Hu12/vVJPx
         33Ow==
X-Gm-Message-State: APjAAAXJfcq4l7E0GliOdHhUyDDEUbsTjsNYq08Lbdx+mhwSmTvZh4Ys
        PVLT9rEkFnSC+XU/Is+YDSVFhA==
X-Google-Smtp-Source: APXvYqwsAtUxAaHjAtYZMoBiVApRYRQ2crqmEEtw1QLeZhNeyTsAClfRDvlyvl4aHjq6jhkQvhRhgw==
X-Received: by 2002:adf:f050:: with SMTP id t16mr4081942wro.99.1561567125151;
        Wed, 26 Jun 2019 09:38:45 -0700 (PDT)
Received: from localhost ([149.62.204.238])
        by smtp.gmail.com with ESMTPSA id y184sm2678653wmg.14.2019.06.26.09.38.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 09:38:44 -0700 (PDT)
Date:   Wed, 26 Jun 2019 19:38:41 +0300
In-Reply-To: <20190626192254.2bd41a40@eyal-ubuntu>
References: <20190626115855.13241-1-nikolay@cumulusnetworks.com> <20190626115855.13241-3-nikolay@cumulusnetworks.com> <20190626163353.6d5535cb@jimi> <9a3be271-af15-3fef-9612-7a3232d09b32@cumulusnetworks.com> <20190626192254.2bd41a40@eyal-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next 2/5] net: sched: em_ipt: set the family based on the protocol when matching
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, jhs@mojatatu.com
From:   nikolay@cumulusnetworks.com
Message-ID: <55E75AF3-EEFA-4AD3-B34D-470E16071DAC@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 June 2019 19:22:54 EEST, Eyal Birger <eyal=2Ebirger@gmail=2Ecom> wrot=
e:
>On Wed, 26 Jun 2019 16:45:28 +0300
>Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom> wrote:
>
>> On 26/06/2019 16:33, Eyal Birger wrote:
>> > Hi Nikolay,
>> >   =20
>> > On Wed, 26 Jun 2019 14:58:52 +0300
>> > Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom> wrote:
>> >  =20
>> >> Set the family based on the protocol otherwise protocol-neutral
>> >> matches will have wrong information (e=2Eg=2E NFPROTO_UNSPEC)=2E In
>> >> preparation for using NFPROTO_UNSPEC xt matches=2E
>> >>
>> >> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom>
>> >> ---
>> >>  net/sched/em_ipt=2Ec | 4 +++-
>> >>  1 file changed, 3 insertions(+), 1 deletion(-)
>> >>
>=2E=2E=2E
>> >> -	nf_hook_state_init(&state, im->hook, im->match->family,
>> >> +	nf_hook_state_init(&state, im->hook, state=2Epf,
>> >>  			   indev ?: skb->dev, skb->dev, NULL,
>> >> em->net, NULL);=20
>> >>  	acpar=2Ematch =3D im->match; =20
>> >=20
>> > I think this change is incompatible with current behavior=2E
>> >=20
>> > Consider the 'policy' match which matches the packet's xfrm state
>> > (sec_path) with the provided user space parameters=2E The sec_path
>> > includes information about the encapsulating packet's parameters
>> > whereas the current skb points to the encapsulated packet, and the
>> > match is done on the encapsulating packet's info=2E
>> >=20
>> > So if you have an IPv6 packet encapsulated within an IPv4 packet,
>> > the match parameters should be done using IPv4 parameters, not
>IPv6=2E
>> >=20
>> > Maybe use the packet's family only if the match family is UNSPEC?
>> >=20
>> > Eyal=2E
>> >  =20
>>=20
>> Hi Eyal,
>> I see your point, I was wondering about the xfrm cases=2E :)
>> In such case I think we can simplify the set and do it only on UNSPEC
>> matches as you suggest=2E
>>=20
>> Maybe we should enforce the tc protocol based on the user-specified
>> nfproto at least from iproute2 otherwise people can add mismatching
>> rules (e=2Eg=2E nfproto =3D=3D v6, tc proto =3D=3D v4)=2E
>>=20
>Hi Nik,
>
>I think for iproute2 the issue is the same=2E For encapsulated IPv6 in
>IPv4 for example, tc proto will be IPv6 (tc sees the encapsulated
>packet after decryption) whereas nfproto will be IPv4 (policy match is
>done on the encapsulating state metadata which is IPv4)=2E
>
>I think the part missing in iproute2 is the ability to specify
>NFPROTO_UNSPEC=2E
>
>Thanks,
>Eyal

Right, I answered too quickly, it makes sense to mix them for xt policy=2E
I also plan to add support for clsact, it should be trivial and iproute2-o=
nly
change=2E
 =20
Thanks,=20
  Nik

