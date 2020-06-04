Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C65B1EE5C0
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 15:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgFDNtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 09:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbgFDNtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 09:49:19 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC4EC08C5C1
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 06:49:19 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id er17so2912413qvb.8
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 06:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L2kVTLYGkWlY2RoLy+YWDfX+gBMBQxvFNN4rH8u5Vno=;
        b=Hp+8QAe3eWsc5sw0i2wCpmHCHXhtTikBnQzxVZbQ7vF6KSFDD3yOn8LjQE1EF/m20o
         itInYeVTAdKziZaIzcYEjciBLRIQSoGNYl2rdLSpqUdAXkmPTls7bw4x0Uo1qvocy0CA
         qzIhBPj2il9XuLcypYT8ltcIF9zeKAr4A3zjPixdUA+XNu2wjV6w/niAfNmBTpv/rltp
         CQInUFnV7ppp9t4Am6u0TcUeTT4hsyCpr6WLqmLgx5jF/OR6WMQQ/hrinGUCrASm/jXV
         M2TuGM4W/H7S0X6Iwi6L1mujLFH+Lkc08dqaStAs/CJ1q1nTTgjLZTaGvKm8Z+gfbYGz
         h58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L2kVTLYGkWlY2RoLy+YWDfX+gBMBQxvFNN4rH8u5Vno=;
        b=aPj7s6ACv10b7FCYdQqxooAqSedo3g+G86jugWKVYS9qrmMAGAkRD2TNLM8DV7uTQ0
         lKNRG5EWwYt8WZXoJprHXGWkW4jLicYPf9ttJSrcoODut/f1V583Uu2zHzN6DdCQScyI
         9tBFfQ1vxnJnAeNpLoIvgmzWHvVxl2abQPwpei9pN6GCWvlbYT7jUGsHUDamvekXBlsJ
         e96J0Ag8oDcdtngZg87KZitBZGqBgJGad9ft+xHUWMBpev9PRpb3MZ6IXgVrq8dIm0U6
         T4vVyScMJoTyudaqi0CVk2KdFPKZoJ/MjwMnTmwFJWFNDhZiJiadOyhXpItM8JVc0eIY
         +cNA==
X-Gm-Message-State: AOAM532wwG4c6jM1jRc6su/2P5pDH0oHg5hLHC2qDgYWwqIF4zPDAJE8
        c7vyXfAMSeQbigSMCIU4QWm0kpXm
X-Google-Smtp-Source: ABdhPJxjtme0/oHb+4exMNAfSwdTyDveHpgrxpthwreFxFGzyYJc3sGXovTISugw1SCvwKcuKUOe8Q==
X-Received: by 2002:ad4:5492:: with SMTP id q18mr4831072qvy.166.1591278557599;
        Thu, 04 Jun 2020 06:49:17 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id r57sm5250892qtr.41.2020.06.04.06.49.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 06:49:15 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id n5so2970315ybo.7
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 06:49:14 -0700 (PDT)
X-Received: by 2002:a25:aa70:: with SMTP id s103mr8308636ybi.492.1591278554013;
 Thu, 04 Jun 2020 06:49:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080535.1427-1-victor@inliniac.net> <CA+FuTSfD2-eF0H=Qu09=JXK6WTiWKNtcqRXqv3TfMfB-=0GiMg@mail.gmail.com>
 <b0a9d785-9d5e-9897-b051-6d9a1e8f914e@inliniac.net> <CA+FuTSd07inNysGhx088hq_jybrikSQdxw8HYjmP84foXhnXOA@mail.gmail.com>
 <06479df9-9da4-dbda-5bd1-f6e4d61471d0@inliniac.net> <CA+FuTSci29=W89CLweZcW=RTKwEXpUdPjsLGTB95iSNcnpU_Lw@mail.gmail.com>
 <6a3dcce9-4635-28e9-d78e-1c7f1f7874da@inliniac.net> <CA+FuTSdmtC4+0cnC2K1gwRLksXgb4hffUpyRbHjjGZbOJOfL0w@mail.gmail.com>
 <21a2224a-65f2-6375-589d-9cadb4fab840@inliniac.net> <CA+FuTSdczH+i8+FO+eQ+OT4-bsRAKG+jacPiuRu3jMszpV_2XA@mail.gmail.com>
 <904a4ad6-650b-8097-deff-989f1936064b@inliniac.net>
In-Reply-To: <904a4ad6-650b-8097-deff-989f1936064b@inliniac.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Jun 2020 09:48:37 -0400
X-Gmail-Original-Message-ID: <CA+FuTScfqM-okTLa1JfkDuhnKZ4DTxmupCwc0NrJQbM0PZ3ssg@mail.gmail.com>
Message-ID: <CA+FuTScfqM-okTLa1JfkDuhnKZ4DTxmupCwc0NrJQbM0PZ3ssg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] af-packet: new flag to indicate all csums are good
To:     Victor Julien <victor@inliniac.net>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Dumazet <edumazet@google.com>,
        Mao Wenan <maowenan@huawei.com>, Arnd Bergmann <arnd@arndb.de>,
        Neil Horman <nhorman@tuxdriver.com>, linux-doc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Drozdov <al.drozdov@gmail.com>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 5:47 AM Victor Julien <victor@inliniac.net> wrote:
>
> On 02-06-2020 22:18, Willem de Bruijn wrote:
> > On Tue, Jun 2, 2020 at 4:05 PM Victor Julien <victor@inliniac.net> wrote:
> >>
> >> On 02-06-2020 21:38, Willem de Bruijn wrote:
> >>> On Tue, Jun 2, 2020 at 3:22 PM Victor Julien <victor@inliniac.net> wrote:
> >>>>
> >>>> On 02-06-2020 21:03, Willem de Bruijn wrote:
> >>>>> On Tue, Jun 2, 2020 at 2:31 PM Victor Julien <victor@inliniac.net> wrote:
> >>>>>> On 02-06-2020 19:37, Willem de Bruijn wrote:
> >>>>>>> On Tue, Jun 2, 2020 at 1:03 PM Victor Julien <victor@inliniac.net> wrote:
> >>>>>>>>
> >>>>>>>> On 02-06-2020 16:29, Willem de Bruijn wrote:
> >>>>>>>>> On Tue, Jun 2, 2020 at 4:05 AM Victor Julien <victor@inliniac.net> wrote:
> >>>>>>>>>>
> >>>>>>>>>> Introduce a new flag (TP_STATUS_CSUM_UNNECESSARY) to indicate
> >>>>>>>>>> that the driver has completely validated the checksums in the packet.
> >>>>>>>>>>
> >>>>>>>>>> The TP_STATUS_CSUM_UNNECESSARY flag differs from TP_STATUS_CSUM_VALID
> >>>>>>>>>> in that the new flag will only be set if all the layers are valid,
> >>>>>>>>>> while TP_STATUS_CSUM_VALID is set as well if only the IP layer is valid.
> >>>>>>>>>
> >>>>>>>>> transport, not ip checksum.
> >>>>>>>>
> >>>>>>>> Allow me a n00b question: what does transport refer to here? Things like
> >>>>>>>> ethernet? It isn't clear to me from the doc.
> >>>>>>>
> >>>>>>> The TCP/UDP/.. transport protocol checksum.
> >>>>>>
> >>>>>> Hmm that is what I thought originally, but then it didn't seem to work.
> >>>>>> Hence my patch.
> >>>>>>
> >>>>>> However I just redid my testing. I took the example tpacketv3 program
> >>>>>> and added the status flag checks to the 'display()' func:
> >>>>>>
> >>>>>>                 if (ppd->tp_status & TP_STATUS_CSUM_VALID) {
> >>>>>>                         printf("TP_STATUS_CSUM_VALID, ");
> >>>>>>                 }
> >>>>>>                 if (ppd->tp_status & (1<<8)) {
> >>>>>>                         printf("TP_STATUS_CSUM_UNNECESSARY, ");
> >>>>>>
> >>>>>>                 }
> >>>>>>
> >>>>>> Then using scapy sent some packets in 2 variants:
> >>>>>> - default (good csums)
> >>>>>> - deliberately bad csums
> >>>>>> (then also added a few things like ip6 over ip)
> >>>>>>
> >>>>>>
> >>>>>> srp1(Ether()/IP(src="1.2.3.4", dst="5.6.7.8")/IPv6()/TCP(),
> >>>>>> iface="enp1s0") // good csums
> >>>>>>
> >>>>>> srp1(Ether()/IP(src="1.2.3.4", dst="5.6.7.8")/IPv6()/TCP(chksum=1),
> >>>>>> iface="enp1s0") //bad tcp
> >>>>>
> >>>>> Is this a test between two machines? What is the device driver of the
> >>>>> machine receiving and printing the packet? It would be helpful to know
> >>>>> whether this uses CHECKSUM_COMPLETE or CHECKSUM_UNNECESSARY.
> >>>>
> >>>> Yes 2 machines, or actually 2 machines and a VM. The receiving Linux
> >>>> sits in a kvm vm with network pass through and uses the virtio driver
> >>>> (host uses e1000e). Based on a quick 'git grep CHECKSUM_UNNECESSARY'
> >>>> virtio seems to support that.
> >>>>
> >>>> I've done some more tests. In a pcap replay that I know contains packet
> >>>> with bad TCP csums (but good IP csums for those pkts), to a physical
> >>>> host running Ubuntu Linux kernel 5.3:
> >>>>
> >>>> - receiver uses nfp (netronome) driver: TP_STATUS_CSUM_VALID set for
> >>>> every packet, including the bad TCP ones
> >>>> - receiver uses ixgbe driver: TP_STATUS_CSUM_VALID not set for the bad
> >>>> packets.
> >>>
> >>> Great. Thanks a lot for running all these experiments.
> >>>
> >>> We might have to drop the TP_STATUS_CSUM_VALID with CHECKSUM_COMPLETE
> >>> unless skb->csum_valid.
> >>>
> >>> For packets with multiple transport layer checksums,
> >>> CHECKSUM_UNNECESSARY should mean that all have been verified.
> >>>
> >>> I believe that in the case of multiple transport headers, csum_valid
> >>> similarly ensures all checksums up to csum_start are valid. Will need
> >>> to double check.
> >>>
> >>> If so, there probably is no need for a separate new TP_STATUS.
> >>> TP_STATUS_CSUM_VALID is reported only when all checksums are valid.
> >>
> >> So if I understand you correctly the key may be in the call to
> >> `skb_csum_unnecessary`:
> >>
> >> That reads:
> >>
> >> static inline int skb_csum_unnecessary(const struct sk_buff *skb)
> >> {
> >>         return ((skb->ip_summed == CHECKSUM_UNNECESSARY) ||
> >>                 skb->csum_valid ||
> >>                 (skb->ip_summed == CHECKSUM_PARTIAL &&
> >>                  skb_checksum_start_offset(skb) >= 0));
> >> }
> >>
> >> But really only the first 2 conditions are reachable
> >
> > .. from this codepath. That function is called in other codepaths as well.
> >
> >> , as we already know
> >> skb->ip_summed is not CHECKSUM_PARTIAL when we call it.
> >>
> >> So our unmodified check is:
> >>
> >>         else if (skb->pkt_type != PACKET_OUTGOING &&
> >>                 (skb->ip_summed == CHECKSUM_COMPLETE ||
> >>                  skb->ip_summed == CHECKSUM_UNNECESSARY ||
> >>                  skb->csum_valid))
> >>
> >> Should this become something like:
> >>
> >>         else if (skb->pkt_type != PACKET_OUTGOING &&
> >>                 (skb->ip_summed == CHECKSUM_COMPLETE &&
> >>                  skb->csum_valid) ||
> >>                  skb->ip_summed == CHECKSUM_UNNECESSARY)
> >>
> >> Is this what you had in mind?
> >
> > I don't suggest modifying skb_csum_unnecessary probably. Certainly not
> > until I've looked at all other callers of it.
> >
> > But in case of packet sockets, yes, adding that csum_valid check is my
> > first rough approximation.
> >
> > That said, first let's give others more familiar with
> > TP_STATUS_CSUM_VALID some time to comment.
> >
>
> I did some more experiments, on real hw this time. I made the following
> change to 5.7.0 (wasn't brave enough to remote upgrade a box to netnext):
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 29bd405adbbd..3afb1913837a 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2216,8 +2216,8 @@ static int tpacket_rcv(struct sk_buff *skb, struct
> net_device *dev,
>         if (skb->ip_summed == CHECKSUM_PARTIAL)
>                 status |= TP_STATUS_CSUMNOTREADY;
>         else if (skb->pkt_type != PACKET_OUTGOING &&
> -                (skb->ip_summed == CHECKSUM_COMPLETE ||
> -                 skb_csum_unnecessary(skb)))
> +                ((skb->ip_summed == CHECKSUM_COMPLETE &&
> skb->csum_valid) ||
> +                  skb->ip_summed == CHECKSUM_UNNECESSARY))
>                 status |= TP_STATUS_CSUM_VALID;
>
>         if (snaplen > res)
>
> With this change it seems the TP_STATUS_CSUM_VALID flag is *never* set
> for the nfp driver.

I was mistaken. skb->csum_valid only signals whether the skb->csum
field is initialized. As of commit 573e8fca255a ("net: skb_gro_checksum_*
functions") skb->csum_valid it is always set if CHECKSUM_COMPLETE.
This does not imply that the checksum field in the header is correct.

The checksum field may get checked against the known checksum of
the payload in skb->csum before __netif_receive_skb_core and thus
before packet sockets during GRO when that is enabled. But not
always. Not if the packet gets flushed, for instance, see tcp4_gro_receive.

Commit 662880f44203 ("net: Allow GRO to use and set levels of checksum
unnecessary") indicates that the original assumption in this patch
that CHECKSUM_UNNECESSARY implies all checksums being valid does not
necessarily hold. Drivers are expected to set up skb->csum_level when
they have verified more than just the inner transport header.
