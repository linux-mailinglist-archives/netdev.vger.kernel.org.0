Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6F64FA076
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 02:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbiDIAMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 20:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbiDIAMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 20:12:34 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873D469CDD;
        Fri,  8 Apr 2022 17:10:29 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z1so15078840wrg.4;
        Fri, 08 Apr 2022 17:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Em4XLbKn3weeywAuYbLh67KeJT9mzRe61DWplVcKypI=;
        b=naC9lKldrkSC7zCNFHhRAhqGVylvW15bkJQAqbkOKBWu7ygsCW7RbzcCayG3jCmi15
         Z17Hl61Nd70wx+plx5gpgJccrGheKPucirRczR2qSH+bdSOFKkTGLaimnmt0QSIedPHd
         6LEfWoxB4+vmvFcRQ2FzmnD1Upp7GVpVposZ5+MgKTU7z7mzymjGpbjC6pJH3Iw0jnP5
         zUSwfuNlHPdZqjAs9DNOxxJUJbDhZKsK1ztu+U13BmJefTSRslhyvZL4HW9w+ZkAX4q6
         eLRdyeLZk35841OgOMea3Ei245zZ0hZuxWYVq9No4cTXAde0yllcDHtvWhaglNko2x70
         ezYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Em4XLbKn3weeywAuYbLh67KeJT9mzRe61DWplVcKypI=;
        b=q9PEWo4MMIt7llzXVPQn+gtJxgsoNxOch956eP/PMCWlGvud9mfrYYwRSKXbRbP38x
         As9DURvE2DR4rwLEpqhDq5Eqt0cWMiok+ZttXhLxq7IR3SRv8+08UHV+X7UWQwWg7cAD
         7bitA0Q3aw/8/taiNHkRB/g3blUVLhklHmiApmLXjTHIAliKsTKEC9S0N/k0blUdW33I
         GZsBVcHk+y8QsOPyKabOBbJc47sGxRXw3IEhq/eTOJ8Vkyd3TGr2/BBJlJ1b5MpbnAB2
         LziSIjD5tv8eMyuzbC8NEc/3PoKeIu7CKQrGrI2P6ObGim70hQ0qZWl+NluskdfEeAV3
         wjPA==
X-Gm-Message-State: AOAM5305WYmluwiSwGOPvwIKaDStbrRKUtiv2Gqn3G+M007saDAv5cqH
        LycDuAdHN+dOJ4U3/bgLVHU=
X-Google-Smtp-Source: ABdhPJzmLwsA1+SOQhHbzMNFbQhPfQg3DyyzoBI32JG9626vpPcnl/Yxmvz41FJyi8uwyoDEhq0KAw==
X-Received: by 2002:a5d:558f:0:b0:206:c79:8d46 with SMTP id i15-20020a5d558f000000b002060c798d46mr16261274wrv.628.1649463027998;
        Fri, 08 Apr 2022 17:10:27 -0700 (PDT)
Received: from smtpclient.apple ([185.238.38.242])
        by smtp.gmail.com with ESMTPSA id c186-20020a1c35c3000000b0038e6c6fc860sm11450767wma.37.2022.04.08.17.10.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Apr 2022 17:10:27 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next 11/15] sfc: Remove usage of list iterator for
 list_add() after the loop body
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <4520e9c5-8871-b281-f621-ac737e64333b@gmail.com>
Date:   Sat, 9 Apr 2022 02:10:24 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B21A2B9D-4B5F-47D2-A990-D17DC56C0A69@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-12-jakobkoschel@gmail.com>
 <4520e9c5-8871-b281-f621-ac737e64333b@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Edward,

> On 7. Apr 2022, at 19:42, Edward Cree <ecree.xilinx@gmail.com> wrote:
>=20
> On 07/04/2022 11:28, Jakob Koschel wrote:
>> In preparation to limit the scope of a list iterator to the list
>> traversal loop, use a dedicated pointer to point to the found element =
[1].
>>=20
>> Before, the code implicitly used the head when no element was found
>> when using &pos->list. Since the new variable is only set if an
>> element was found, the list_add() is performed within the loop
>> and only done after the loop if it is done on the list head directly.
>>=20
>> Link: =
https://lore.kernel.org/all/CAHk-=3DwgRr_D8CB-D9Kg-c=3DEHreAsk5SqXPwr9Y7k9=
sA6cWXJ6w@mail.gmail.com/ [1]
>> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>=20
> The commit message doesn't accurately describe the patch; it states
> that "the list_add() is performed within the loop", which doesn't
> appear to be the case.

you're right, I've changed the code last minute. I'll make sure
the changelog reflects the actual behaviour here. Thanks for the
input!

> Also it seems a bit subtle to use `head` as both the head of the
> list to iterate over and the found entry/gap to insert before; a
> comment explaining that wouldn't go amiss.

Also a good point, I'll add a comment as well, or perhaps using
a separate 'struct list_head *pos' variable is even cleaner.

> (I'd question whether this change is really an improvement in this
> case, where the iterator really does hold the thing we want at the
> end of the search and so there's no if(found) special-casing =E2=80=94
> we're not even abusing the type system, because efx->rss_context
> is of the same type as all the list entries, so ctx really is a
> valid pointer and there shouldn't be any issues with speculative
> accesses or whatever =E2=80=94 but it seems Linus has already =
pronounced
> in favour of the scope limiting, and far be it from me to gainsay
> him.)

So, since the head is included in the struct of the same type as
the element, it really doesn't make much of a difference here.
It will always be safe to use.

But this is the very rare exception. There are other benefits of
avoiding the use of list iterator after the loop. One of them
is scope limiting but you also might want to set the iterator
variable to a "safe value" before the processor might execute an =
additional
iteration in speculative execution on the 'bogus' head element.

If you do these kind of patches on the list macros, you need to make =
sure
they work for all the uses, including the safe ones (like this one).

>=20
> -ed
>=20
>> ---
>> drivers/net/ethernet/sfc/rx_common.c | 6 ++++--
>> 1 file changed, 4 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/net/ethernet/sfc/rx_common.c =
b/drivers/net/ethernet/sfc/rx_common.c
>> index 1b22c7be0088..a8822152ff83 100644
>> --- a/drivers/net/ethernet/sfc/rx_common.c
>> +++ b/drivers/net/ethernet/sfc/rx_common.c
>> @@ -563,8 +563,10 @@ struct efx_rss_context =
*efx_alloc_rss_context_entry(struct efx_nic *efx)
>>=20
>> 	/* Search for first gap in the numbering */
>> 	list_for_each_entry(ctx, head, list) {
>> -		if (ctx->user_id !=3D id)
>> +		if (ctx->user_id !=3D id) {
>> +			head =3D &ctx->list;
>> 			break;
>> +		}
>> 		id++;
>> 		/* Check for wrap.  If this happens, we have nearly 2^32
>> 		 * allocated RSS contexts, which seems unlikely.
>> @@ -582,7 +584,7 @@ struct efx_rss_context =
*efx_alloc_rss_context_entry(struct efx_nic *efx)
>>=20
>> 	/* Insert the new entry into the gap */
>> 	new->user_id =3D id;
>> -	list_add_tail(&new->list, &ctx->list);
>> +	list_add_tail(&new->list, head);
>> 	return new;
>> }
>>=20
>>=20
>=20

Thanks,
Jakob

