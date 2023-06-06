Return-Path: <netdev+bounces-8545-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 537167247F8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84D681C20A48
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB8A30B68;
	Tue,  6 Jun 2023 15:39:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDAE37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:39:46 +0000 (UTC)
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFF610D1
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:39:44 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 3f1490d57ef6-bb167972cffso7766473276.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 08:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686065983; x=1688657983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=elTBqfUhPXSPyDwW3mi+yRAT2Okd4Dn54wk2+xqX2uE=;
        b=rtwZNt1EG2rvaIQ3g0XQOeXafgz9lj2O4EZGXPm8k2SAGvhSVzmpija/Byq7Ikvzyv
         RabBusq0CTYp1R7MXvDA0x0MfddvGSvaHyuBPRomUw4Eg1auAAYHujXW+hJtMPDBwQEg
         +dgYzjo50cwXSBqu+bYfmD1WFBdOY9mouOrrylGfg2z9yWS3AcLG4ed4u5fRB1I//PaY
         AKQTsUu7jCLe/Z5mrAkQO8rrWsh5OmMZHvgUm1BrUPVc/dqp/nWkVaedAHhVhF6BJjeT
         ZfmUk+mWccMp3GQGUHoH+24iU+prN9i/ho5ep5PG5sGrnMwRyk3rH2vpaBdJSpPVNWjS
         QlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686065983; x=1688657983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=elTBqfUhPXSPyDwW3mi+yRAT2Okd4Dn54wk2+xqX2uE=;
        b=g6TG/c2Q5iE7ZDOfhx/BTtOgtWAf4TwRlns+vgHUHs3xSnmV1OM1UKdiRP3kic1Er1
         ERcjuWkQOx79oP3oOTRBF8iuLJm2C2s1Zy29N7jLBQhfdFySHS/RhyoP1f7RaGN49MiC
         sjKYheVnNG9zeFMY4wFTIAPExD63XOxNJiKn9zEPSWngqzBdyn9sUfgVsNpXYQlHTG4h
         +fBwSSnl/kx/9e+ASgDkZxo05dU/89UfFG2nMVrS8QFdQ3uJqoX+ELIVtyM56KqW6hjG
         lskykuOIoO8EavM58uDhW3L1SOEZ3aspGkmhLty4zrHnMF9nryvzmvq1r7fr53YBBf1i
         bxrw==
X-Gm-Message-State: AC+VfDynS3c650kw2Icg8j8BIEQ/vIsQ8gD0DcmMAkJST16CvPe68BW6
	8/XnVkWNQpdqKkprpZLTQw9GCi8rtCGga2sOebpKRQ==
X-Google-Smtp-Source: ACHHUZ6AbldddbAsOhtAOSD4tHHYX3Z/CCZtQcDWqnC9xbTaFKB8pD7G4yqlPp6lz2sDL0oyfz8R4u+lgk8ScfFX0JE=
X-Received: by 2002:a0d:df93:0:b0:567:2891:a2ec with SMTP id
 i141-20020a0ddf93000000b005672891a2ecmr2323430ywe.22.1686065983484; Tue, 06
 Jun 2023 08:39:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
 <CAM0EoMnqscw=OfWzyEKV10qFW5+EFMd5JWZxPSPCod3TvqpnuQ@mail.gmail.com> <20230605165353.tnjrwa7gbcp4qhim@skbuf>
In-Reply-To: <20230605165353.tnjrwa7gbcp4qhim@skbuf>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 6 Jun 2023 11:39:32 -0400
Message-ID: <CAM0EoM=qG9sDjM=F6D=i=h3dKXwQXAt1wui8W_EXDJi2tijRnw@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next 0/5] Improve the taprio qdisc's
 relationship with its children
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, linux-kernel@vger.kernel.org, 
	intel-wired-lan@lists.osuosl.org, 
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>, Peilin Ye <yepeilin.cs@gmail.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Vladimir,

On Mon, Jun 5, 2023 at 12:53=E2=80=AFPM Vladimir Oltean <vladimir.oltean@nx=
p.com> wrote:
>
> Hi Jamal,
>
> On Mon, Jun 05, 2023 at 11:44:17AM -0400, Jamal Hadi Salim wrote:
> > I havent been following - but if you show me sample intended tc
> > configs for both s/w and hardware offloads i can comment.
>
> There is not much difference in usage between the 2 modes. IMO the softwa=
re
> data path logic is only a simulation for demonstrative purposes of what t=
he
> shaper is intended to do. If hardware offload is available, it is always
> preferable. Otherwise, I'm not sure if anyone uses the pure software
> scheduling mode (also without txtime assist) for a real life use case.
>

Thanks for the sample. Understood on the software twin being useful
for simulation (our standard rule is you need to have a software twin)
- it is great you conform to that.

I took a cursory glance at the existing kernel code in order to get
better context (I will make more time later). Essentially this qdisc
is classful and is capable of hardware offload. Initial comments are
unrelated to the patchset (all this Klingon DCB thingy configuration
like a flag 0x2 is still magic to me).

1)Just some details become confusing in regards to offload vs not; F.e
class grafting (taprio_graft()) is de/activating the device but that
seems only needed for offload. Would it not be better to have those
separate and call graft_offload vs graft_software, etc? We really need
to create a generic document on how someone would write code for
qdiscs for consistency (I started working on one but never completed
it - if there is a volunteer i would be happy to work with one to
complete it).
2) It seems like in mqprio this qdisc can only be root qdisc (like
mqprio) and you dont want to replace the children with other types of
qdiscs i.e the children are always pfifo? i.e is it possible or
intended for example to replace 8001:x with bfifo etc? or even change
the pfifo queue size, etc?
3) Offload intention seems really to be bypassing enqueue() and going
straigth to the driver xmit() for a specific DMA ring that the skb is
mapped to. Except for the case where the driver says it's busy and
refuses to stash the skb in ring in which case you have to requeue to
the appropriate child qdisc/class. I am not sure how that would work
here - mqprio gets away with it by not defining any of the
en/de/requeue() callbacks - but likely it will be the lack of requeue
that makes it work.

 I will read the other thread you pointed to when i get a moment.

cheers,
jamal

> I was working with something like this for testing the code paths affecte=
d
> by these changes:
>
> #!/bin/bash
>
> add_taprio()
> {
>         local offload=3D$1
>         local extra_flags
>
>         case $offload in
>         true)
>                 extra_flags=3D"flags 0x2"
>                 ;;
>         false)
>                 extra_flags=3D"clockid CLOCK_TAI"
>                 ;;
>         esac
>
>         tc qdisc replace dev eno0 handle 8001: parent root stab overhead =
24 taprio \
>                 num_tc 8 \
>                 map 0 1 2 3 4 5 6 7 \
>                 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
>                 max-sdu 0 0 0 0 0 200 0 0 \
>                 base-time 200 \
>                 sched-entry S 80 20000 \
>                 sched-entry S a0 20000 \
>                 sched-entry S 5f 60000 \
>                 $extra_flags
> }
>
> add_cbs()
> {
>         local offload=3D$1
>         local extra_flags
>
>         case $offload in
>         true)
>                 extra_flags=3D"offload 1"
>                 ;;
>         false)
>                 extra_flags=3D""
>                 ;;
>         esac
>
>         max_frame_size=3D1500
>         data_rate_kbps=3D20000
>         port_transmit_rate_kbps=3D1000000
>         idleslope=3D$data_rate_kbps
>         sendslope=3D$(($idleslope - $port_transmit_rate_kbps))
>         locredit=3D$(($max_frame_size * $sendslope / $port_transmit_rate_=
kbps))
>         hicredit=3D$(($max_frame_size * $idleslope / $port_transmit_rate_=
kbps))
>         tc qdisc replace dev eno0 parent 8001:8 cbs \
>                 idleslope $idleslope \
>                 sendslope $sendslope \
>                 hicredit $hicredit \
>                 locredit $locredit \
>                 $extra_flags
> }
>
> # this should always fail
> add_second_taprio()
> {
>         tc qdisc replace dev eno0 parent 8001:7 taprio \
>                 num_tc 8 \
>                 map 0 1 2 3 4 5 6 7 \
>                 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
>                 max-sdu 0 0 0 0 0 200 0 0 \
>                 base-time 200 \
>                 sched-entry S 80 20000 \
>                 sched-entry S a0 20000 \
>                 sched-entry S 5f 60000 \
>                 clockid CLOCK_TAI
> }
>
> ip link set eno0 up
>
> echo "Offload:"
> add_taprio true
> add_cbs true
> add_second_taprio
> mausezahn eno0 -t ip -b 00:04:9f:05:f6:27 -c 100 -p 60
> sleep 5
> tc -s class show dev eno0
> tc qdisc del dev eno0 root
>
> echo "Software:"
> add_taprio false
> add_cbs false
> add_second_taprio
> mausezahn eno0 -t ip -b 00:04:9f:05:f6:27 -c 100 -p 60
> sleep 5
> tc -s class show dev eno0
> tc qdisc del dev eno0 root
>
> > In my cursory look i assumed you wanted to go along the path of mqprio
> > where nothing much happens in the s/w datapath other than requeues
> > when the tx hardware path is busy (notice it is missing an
> > enqueue/deque ops). In that case the hardware selection is essentially
> > of a DMA ring based on skb tags. It seems you took it up a notch by
> > infact having a choice of whether to have pure s/w or offload path.
>
> Yes. Actually the original taprio design always had the enqueue()/dequeue=
()
> ops involved in the data path, then commit 13511704f8d7 ("net: taprio
> offload: enforce qdisc to netdev queue mapping") retrofitted the mqprio
> model when using the "flags 0x2" argument.


> If you have time to read, the discussion behind that redesign was here:
> https://lore.kernel.org/netdev/20210511171829.17181-1-yannick.vignon@oss.=
nxp.com/

