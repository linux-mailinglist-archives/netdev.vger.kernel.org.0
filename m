Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B19461767
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239751AbhK2OGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:06:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240286AbhK2OEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:04:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638194464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IeyJNwcYSO8NniImbH4OBp4zuND8RtpEhu/U4fbs0jQ=;
        b=ecYpAgdRSwfsvub2t+xsG2tOM4E8lizWhv3amufzy+KGaqXkKfmd+BoWoB8fNVewDreMMD
        ReZZIPIJEWGclRSq3IiBnNvovygeV9oPpig8xyiXDroKJh19cAytTUKZBKZokhVVlzHdqP
        L4jzh0fMTjnYB8IATn67+bCYYUtJ8oY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-2n-54mIWOcSU4lPog9LpZA-1; Mon, 29 Nov 2021 08:59:58 -0500
X-MC-Unique: 2n-54mIWOcSU4lPog9LpZA-1
Received: by mail-ed1-f69.google.com with SMTP id l15-20020a056402124f00b003e57269ab87so13780566edw.6
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 05:59:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=IeyJNwcYSO8NniImbH4OBp4zuND8RtpEhu/U4fbs0jQ=;
        b=70bBQjRhogxvSm/dKHPaoJC2UsW+i+fhr3f0386dtPNxEU3G/H3z7EAQSG90htrsyB
         GQdlwO6XuRaqfvmK0jkLCmdRGsFw8dsfkInfMCFXkH5UjQyJ+1v4WQJe36435sz8jred
         D/Igzz8HASMlIfSbTwa0Tk74QgRoW8VAs0Ag9NjEtpJSuqx36wiufaao0KPRvj8Ltbnb
         wfdSvgKGrT//133KNHD43gYMi2H++lpoTAyKPcUvpS8tp1v9RFaMWcBkMptQASNgVfoc
         IYj4R3SezxC/ISVBEYSuuL3L71IlBuojymXDz59LT7FH+nw5kveHWe/QEUOm982OkBk7
         b1ww==
X-Gm-Message-State: AOAM531+9ovhwSweJ+gk7uv9GknOuSZ/Ln/SyMnw3T0PSXHjOcxDzL4A
        mdCKqNhHBSI2xw3oq1PwzrJFHilzS9Od43Ru+y8E2HTEnyq+g7/tXNGvk1a9tlz8dYeWFT0fWq2
        qCr9/RLDJPHGdYbEw
X-Received: by 2002:a17:907:6d28:: with SMTP id sa40mr59414015ejc.201.1638194396747;
        Mon, 29 Nov 2021 05:59:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQSUmsFHsP7WeobINWjGi62cHzP+EzVEFoSxpzCoJ1n2b7WNWfx5UgPNnyFcW6l+Ylh8aSEg==
X-Received: by 2002:a17:907:6d28:: with SMTP id sa40mr59413979ejc.201.1638194396485;
        Mon, 29 Nov 2021 05:59:56 -0800 (PST)
Received: from [192.168.2.13] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id nb4sm7766389ejc.21.2021.11.29.05.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 05:59:55 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <37732c0b-a1f5-5e1d-d34e-16ef07fab597@redhat.com>
Date:   Mon, 29 Nov 2021 14:59:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-22-alexandr.lobakin@intel.com>
 <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net> <87bl28bga6.fsf@toke.dk>
 <20211125170708.127323-1-alexandr.lobakin@intel.com>
 <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125204007.133064-1-alexandr.lobakin@intel.com> <87sfvj9k13.fsf@toke.dk>
 <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <871ae82a-3d5b-2693-2f77-7c86d725a056@iogearbox.net>
 <3c2fd51e-96c4-d500-bb4c-1972bb0fa3d6@iogearbox.net>
In-Reply-To: <3c2fd51e-96c4-d500-bb4c-1972bb0fa3d6@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/11/2021 00.01, Daniel Borkmann wrote:
> On 11/26/21 11:27 PM, Daniel Borkmann wrote:
>> On 11/26/21 7:06 PM, Jakub Kicinski wrote:
> [...]
>>> The information required by the admin is higher level. As you say the
>>> primary concern there is "how many packets did XDP eat".
>>
>> Agree. Above said, for XDP_DROP I would see one use case where you 
>> compare
>> different drivers or bond vs no bond as we did in the past in [0] when
>> testing against a packet generator (although I don't see bond driver 
>> covered
>> in this series here yet where it aggregates the XDP stats from all 
>> bond slave devs).
>>
>> On a higher-level wrt "how many packets did XDP eat", it would make sense
>> to have the stats for successful XDP_{TX,REDIRECT} given these are out
>> of reach from a BPF prog PoV - we can only count there how many times we
>> returned with XDP_TX but not whether the pkt /successfully made it/.
>>

Exactly.

>> In terms of error cases, could we just standardize all drivers on the 
>> behavior
>> of e.g. mlx5e_xdp_handle(), meaning, a failure from XDP_{TX,REDIRECT} will
>> hit the trace_xdp_exception() and then fallthrough to bump a drop counter
>> (same as we bump in XDP_DROP then). So the drop counter will account for
>> program drops but also driver-related drops.
>>

Hmm... I don't agree here.  IMHO the BPF-program's *choice* to drop (via 
XDP_DROP) should NOT share the counter with the driver-related drops.

The driver-related drops must be accounted separate.

For the record, I think mlx5e_xdp_handle() does the wrong thing, of 
accounting everything as XDP_DROP in (rq->stats->xdp_drop++).

Current mlx5 driver stats are highly problematic actually.
Please don't model stats behavior after this driver.

E.g. if BPF-prog takes the *choice* XDP_TX or XDP_REDIRECT or XDP_DROP, 
then the packet is invisible to "ifconfig" stats.  It is like the driver 
never received these packets (which is wrong IMHO). (The stats are only 
avail via ethtool -S).


>> At some later point the trace_xdp_exception() could be extended with 
>> an error
>> code that the driver would propagate (given some of them look quite 
>> similar
>> across drivers, fwiw), and then whoever wants to do further processing 
>> with them can do so via bpftrace or other tooling.

I do like trace_xdp_exception() is invoked in mlx5e_xdp_handle(), but do 
notice that xdp_do_redirect() also have a tracepoint that can be used 
for troubleshooting. (I usually use xdp_monitor for troubleshooting 
which catch both).

I like the stats XDP handling better in mvneta_run_xdp().

> Just thinking out loud, one straight forward example we could start out 
> with that is also related to Paolo's series [1] ...
> 
> enum xdp_error {
>      XDP_UNKNOWN,
>      XDP_ACTION_INVALID,
>      XDP_ACTION_UNSUPPORTED,
> };
> 
> ... and then bpf_warn_invalid_xdp_action() returns one of the latter two
> which we pass to trace_xdp_exception(). Later there could be XDP_DRIVER_*
> cases e.g. propagated from XDP_TX error exceptions.
> 
>          [...]
>          default:
>                  err = bpf_warn_invalid_xdp_action(act);
>                  fallthrough;
>          case XDP_ABORTED:
> xdp_abort:
>                  trace_xdp_exception(rq->netdev, prog, act, err);
>                  fallthrough;
>          case XDP_DROP:
>                  lrstats->xdp_drop++;
>                  break;
>          }
>          [...]
> 
>    [1] 
> https://lore.kernel.org/netdev/cover.1637924200.git.pabeni@redhat.com/
> 
>> So overall wrt this series: from the lrstats we'd be /dropping/ the pass,
>> tx_errors, redirect_errors, invalid, aborted counters. And we'd be 
>> /keeping/
>> bytes & packets counters that XDP sees, (driver-)successful tx & redirect
>> counters as well as drop counter. Also, XDP bytes & packets counters 
>> should
>> not be counted twice wrt ethtool stats.
>>
>>    [0] 
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9e2ee5c7e7c35d195e2aa0692a7241d47a433d1e 
>>

Concrete example with mlx5:

For most other hardware (than mlx5) I experience that XDP_TX creates a 
push-back on NIC RX-handing speed.  Thus, the XDP_TX stats recorded by 
BPF-prog is usually correct.

With mlx5 hardware (tested on ConnectX-5 Ex MT28800) the RX 
packets-per-sec (pps) stats can easily be faster than actually XDP_TX 
transmitted frames.

$ sudo ./xdp_rxq_info --dev mlx5p1 --action XDP_TX
  [...]
  Running XDP on dev:mlx5p1 (ifindex:10) action:XDP_TX options:swapmac
  XDP stats       CPU     pps         issue-pps
  XDP-RX CPU      1       13,922,430  0
  XDP-RX CPU      total   13,922,430

  RXQ stats       RXQ:CPU pps         issue-pps
  rx_queue_index    1:1   13,922,430  0
  rx_queue_index    1:sum 13,922,430

The real xmit speed is (from below ethtool_stats.pl) is
  9,391,314 pps <= rx1_xdp_tx_xmit /sec

The dropped packets are double accounted as:
  4,552,033 <= rx_xdp_drop /sec
  4,552,033 <= rx_xdp_tx_full /sec


Show adapter(s) (mlx5p1) statistics (ONLY that changed!)
Ethtool(mlx5p1  ) stat:       217865 (        217,865) <= ch1_poll /sec
Ethtool(mlx5p1  ) stat:       217864 (        217,864) <= ch_poll /sec
Ethtool(mlx5p1  ) stat:     13943371 (     13,943,371) <= 
rx1_cache_reuse /sec
Ethtool(mlx5p1  ) stat:      4552033 (      4,552,033) <= rx1_xdp_drop /sec
Ethtool(mlx5p1  ) stat:       146740 (        146,740) <= 
rx1_xdp_tx_cqes /sec
Ethtool(mlx5p1  ) stat:      4552033 (      4,552,033) <= 
rx1_xdp_tx_full /sec
Ethtool(mlx5p1  ) stat:      9391314 (      9,391,314) <= 
rx1_xdp_tx_inlnw /sec
Ethtool(mlx5p1  ) stat:       880436 (        880,436) <= 
rx1_xdp_tx_mpwqe /sec
Ethtool(mlx5p1  ) stat:       997833 (        997,833) <= 
rx1_xdp_tx_nops /sec
Ethtool(mlx5p1  ) stat:      9391314 (      9,391,314) <= 
rx1_xdp_tx_xmit /sec
Ethtool(mlx5p1  ) stat:     45095173 (     45,095,173) <= 
rx_64_bytes_phy /sec
Ethtool(mlx5p1  ) stat:   2886090490 (  2,886,090,490) <= rx_bytes_phy /sec
Ethtool(mlx5p1  ) stat:     13943293 (     13,943,293) <= rx_cache_reuse 
/sec
Ethtool(mlx5p1  ) stat:     31151957 (     31,151,957) <= 
rx_out_of_buffer /sec
Ethtool(mlx5p1  ) stat:     45095158 (     45,095,158) <= rx_packets_phy 
/sec
Ethtool(mlx5p1  ) stat:   2886072350 (  2,886,072,350) <= rx_prio0_bytes 
/sec
Ethtool(mlx5p1  ) stat:     45094878 (     45,094,878) <= 
rx_prio0_packets /sec
Ethtool(mlx5p1  ) stat:   2705707938 (  2,705,707,938) <= 
rx_vport_unicast_bytes /sec
Ethtool(mlx5p1  ) stat:     45095129 (     45,095,129) <= 
rx_vport_unicast_packets /sec
Ethtool(mlx5p1  ) stat:      4552033 (      4,552,033) <= rx_xdp_drop /sec
Ethtool(mlx5p1  ) stat:       146739 (        146,739) <= rx_xdp_tx_cqe /sec
Ethtool(mlx5p1  ) stat:      4552033 (      4,552,033) <= rx_xdp_tx_full 
/sec
Ethtool(mlx5p1  ) stat:      9391319 (      9,391,319) <= 
rx_xdp_tx_inlnw /sec
Ethtool(mlx5p1  ) stat:       880436 (        880,436) <= 
rx_xdp_tx_mpwqe /sec
Ethtool(mlx5p1  ) stat:       997831 (        997,831) <= rx_xdp_tx_nops 
/sec
Ethtool(mlx5p1  ) stat:      9391319 (      9,391,319) <= rx_xdp_tx_xmit 
/sec
Ethtool(mlx5p1  ) stat:    601044221 (    601,044,221) <= tx_bytes_phy /sec
Ethtool(mlx5p1  ) stat:      9391316 (      9,391,316) <= tx_packets_phy 
/sec
Ethtool(mlx5p1  ) stat:    601040871 (    601,040,871) <= tx_prio0_bytes 
/sec
Ethtool(mlx5p1  ) stat:      9391264 (      9,391,264) <= 
tx_prio0_packets /sec
Ethtool(mlx5p1  ) stat:    563478483 (    563,478,483) <= 
tx_vport_unicast_bytes /sec
Ethtool(mlx5p1  ) stat:      9391316 (      9,391,316) <= 
tx_vport_unicast_packets /sec



[1] 
https://github.com/netoptimizer/network-testing/blob/master/bin/ethtool_stats.pl


The net_devices stats says the NIC is processing zero packets:

  $ sar -n DEV 2 1000
  [...]
  Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s 
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
  [...]
  Average:       mlx5p1      0,00      0,00      0,00      0,00 
0,00      0,00      0,00      0,00
  Average:       mlx5p2      0,00      0,00      0,00      0,00 
0,00      0,00      0,00      0,00

