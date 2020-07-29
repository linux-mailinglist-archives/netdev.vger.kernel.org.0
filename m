Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA852324C5
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 20:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgG2Sin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 14:38:43 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46861 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726476AbgG2Sil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 14:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596047918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6re5OlrFPTBV7kIK6ytDPkCQZnOD6neICf1b/T9keI0=;
        b=cooRSHzdTtvZA1OzvPKV6ofGNLqnG+/dkB6IjiASsWKSzm2L1XtAWG8H8aVPwwipsrfGxL
        1BtOEwdTyN0O9kjWuIJ3GJo7tsx0Rcy6Ak5gFw9fR3xX/0iu2e1iNMO4sthqrrXIFHtQEL
        Y9nSzSTRKunflnZdL3gQECy4jiPcH44=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-93L7Wi0-PSWthEgKPNQG8Q-1; Wed, 29 Jul 2020 14:38:35 -0400
X-MC-Unique: 93L7Wi0-PSWthEgKPNQG8Q-1
Received: by mail-qt1-f197.google.com with SMTP id k1so2881090qtp.20
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 11:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6re5OlrFPTBV7kIK6ytDPkCQZnOD6neICf1b/T9keI0=;
        b=CVX0LdpbwmmFlLayb/t3ZoeQohHlbVNQv/dtYao5CZCof1QBdh8RxDFrhg1fzi1x8S
         T8gFCDD+s3Z/ObezSmvsMP+5ZFrSqneWBmhiuFSjGLD+CTMekVNwz5ZtN4p7xfMN5xdK
         kaYJ6VaEy7AjC+cMR0arKCK6cen5vfLcawA9DNgE22sQ9vRqmSt1WDkSesRa4jgJG7M3
         KSep+XSjBDOlHAwl6gtG9euBF0NmjTDyQh1QWdJGX2aZGO54tID1cjEOOzYXvfD3wb3k
         ySkmBgNbxxdtT1Z929H03EahWKEOU7OaeYTgtKv+qh1TFWvnSqqYkt3hgCZSqWsWp+tK
         xxCQ==
X-Gm-Message-State: AOAM533jzCF0G4SoNMyLkxdMD81LJQAUTMC2FCx1Ss+QGyu6ck21YAdJ
        W4ZIe0RNaEOs/wUf7JI5mOyxoQc2V6ERwQstZj3l9zl0I2t2r3Q9DK5Gq2VEKnxu+8WZjMc8aAR
        h9IXFG7Pg/mJrYE69wRpUu6RtwZ41J84V
X-Received: by 2002:a0c:b45b:: with SMTP id e27mr22603581qvf.208.1596047912704;
        Wed, 29 Jul 2020 11:38:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyofEG51c0igQYyymjX+UHatTC2o82o95gmHEvhxepT1dgE4EGZj9duNefPYnQ5l0a6qqeXtun2kV2AdGcBBS0=
X-Received: by 2002:a0c:b45b:: with SMTP id e27mr22603549qvf.208.1596047912198;
 Wed, 29 Jul 2020 11:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAJaqyWefMHPguj8ZGCuccTn0uyKxF9ZTEi2ASLtDSjGNb1Vwsg@mail.gmail.com>
 <419cc689-adae-7ba4-fe22-577b3986688c@redhat.com> <CAJaqyWedEg9TBkH1MxGP1AecYHD-e-=ugJ6XUN+CWb=rQGf49g@mail.gmail.com>
 <0a83aa03-8e3c-1271-82f5-4c07931edea3@redhat.com> <CAJaqyWeqF-KjFnXDWXJ2M3Hw3eQeCEE2-7p1KMLmMetMTm22DQ@mail.gmail.com>
 <20200709133438-mutt-send-email-mst@kernel.org> <7dec8cc2-152c-83f4-aa45-8ef9c6aca56d@redhat.com>
 <CAJaqyWdLOH2EceTUduKYXCQUUNo1XQ1tLgjYHTBGhtdhBPHn_Q@mail.gmail.com>
 <20200710015615-mutt-send-email-mst@kernel.org> <CAJaqyWf1skGxrjuT9GLr6dtgd-433y-rCkbtStLHaAs2W2jYXA@mail.gmail.com>
 <20200720051410-mutt-send-email-mst@kernel.org> <d4e29f0451f7551ee3a408ecfa40de2de2b8aa75.camel@redhat.com>
 <a7831eac-6db7-f932-85bc-bbd731a89335@redhat.com>
In-Reply-To: <a7831eac-6db7-f932-85bc-bbd731a89335@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 29 Jul 2020 20:37:55 +0200
Message-ID: <CAJaqyWebQG=sR3Xg3GjHvaA+_6-gXYuYmDW-kBWWacKjTAoMOg@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 4:55 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/7/20 =E4=B8=8B=E5=8D=887:16, Eugenio P=C3=A9rez wrote:
> > On Mon, Jul 20, 2020 at 11:27 AM Michael S. Tsirkin <mst@redhat.com> wr=
ote:
> >> On Thu, Jul 16, 2020 at 07:16:27PM +0200, Eugenio Perez Martin wrote:
> >>> On Fri, Jul 10, 2020 at 7:58 AM Michael S. Tsirkin <mst@redhat.com> w=
rote:
> >>>> On Fri, Jul 10, 2020 at 07:39:26AM +0200, Eugenio Perez Martin wrote=
:
> >>>>>>> How about playing with the batch size? Make it a mod parameter in=
stead
> >>>>>>> of the hard coded 64, and measure for all values 1 to 64 ...
> >>>>>> Right, according to the test result, 64 seems to be too aggressive=
 in
> >>>>>> the case of TX.
> >>>>>>
> >>>>> Got it, thanks both!
> >>>> In particular I wonder whether with batch size 1
> >>>> we get same performance as without batching
> >>>> (would indicate 64 is too aggressive)
> >>>> or not (would indicate one of the code changes
> >>>> affects performance in an unexpected way).
> >>>>
> >>>> --
> >>>> MST
> >>>>
> >>> Hi!
> >>>
> >>> Varying batch_size as drivers/vhost/net.c:VHOST_NET_BATCH,
> >> sorry this is not what I meant.
> >>
> >> I mean something like this:
> >>
> >>
> >> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> >> index 0b509be8d7b1..b94680e5721d 100644
> >> --- a/drivers/vhost/net.c
> >> +++ b/drivers/vhost/net.c
> >> @@ -1279,6 +1279,10 @@ static void handle_rx_net(struct vhost_work *wo=
rk)
> >>          handle_rx(net);
> >>   }
> >>
> >> +MODULE_PARM_DESC(batch_num, "Number of batched descriptors. (offset f=
rom 64)");
> >> +module_param(batch_num, int, 0644);
> >> +static int batch_num =3D 0;
> >> +
> >>   static int vhost_net_open(struct inode *inode, struct file *f)
> >>   {
> >>          struct vhost_net *n;
> >> @@ -1333,7 +1337,7 @@ static int vhost_net_open(struct inode *inode, s=
truct file *f)
> >>                  vhost_net_buf_init(&n->vqs[i].rxq);
> >>          }
> >>          vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
> >> -                      UIO_MAXIOV + VHOST_NET_BATCH,
> >> +                      UIO_MAXIOV + VHOST_NET_BATCH + batch_num,
> >>                         VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
> >>                         NULL);
> >>
> >>
> >> then you can try tweaking batching and playing with mod parameter with=
out
> >> recompiling.
> >>
> >>
> >> VHOST_NET_BATCH affects lots of other things.
> >>
> > Ok, got it. Since they were aligned from the start, I thought it was a =
good idea to maintain them in-sync.
> >
> >>> and testing
> >>> the pps as previous mail says. This means that we have either only
> >>> vhost_net batching (in base testing, like previously to apply this
> >>> patch) or both batching sizes the same.
> >>>
> >>> I've checked that vhost process (and pktgen) goes 100% cpu also.
> >>>
> >>> For tx: Batching decrements always the performance, in all cases. Not
> >>> sure why bufapi made things better the last time.
> >>>
> >>> Batching makes improvements until 64 bufs, I see increments of pps bu=
t like 1%.
> >>>
> >>> For rx: Batching always improves performance. It seems that if we
> >>> batch little, bufapi decreases performance, but beyond 64, bufapi is
> >>> much better. The bufapi version keeps improving until I set a batchin=
g
> >>> of 1024. So I guess it is super good to have a bunch of buffers to
> >>> receive.
> >>>
> >>> Since with this test I cannot disable event_idx or things like that,
> >>> what would be the next step for testing?
> >>>
> >>> Thanks!
> >>>
> >>> --
> >>> Results:
> >>> # Buf size: 1,16,32,64,128,256,512
> >>>
> >>> # Tx
> >>> # =3D=3D=3D
> >>> # Base
> >>> 2293304.308,3396057.769,3540860.615,3636056.077,3332950.846,3694276.1=
54,3689820
> >>> # Batch
> >>> 2286723.857,3307191.643,3400346.571,3452527.786,3460766.857,3431042.5=
,3440722.286
> >>> # Batch + Bufapi
> >>> 2257970.769,3151268.385,3260150.538,3379383.846,3424028.846,3433384.3=
08,3385635.231,3406554.538
> >>>
> >>> # Rx
> >>> # =3D=3D
> >>> # pktgen results (pps)
> >>> 1223275,1668868,1728794,1769261,1808574,1837252,1846436
> >>> 1456924,1797901,1831234,1868746,1877508,1931598,1936402
> >>> 1368923,1719716,1794373,1865170,1884803,1916021,1975160
> >>>
> >>> # Testpmd pps results
> >>> 1222698.143,1670604,1731040.6,1769218,1811206,1839308.75,1848478.75
> >>> 1450140.5,1799985.75,1834089.75,1871290,1880005.5,1934147.25,1939034
> >>> 1370621,1721858,1796287.75,1866618.5,1885466.5,1918670.75,1976173.5,1=
988760.75,1978316
> >>>
> >>> pktgen was run again for rx with 1024 and 2048 buf size, giving
> >>> 1988760.75 and 1978316 pps. Testpmd goes the same way.
> >> Don't really understand what does this data mean.
> >> Which number of descs is batched for each run?
> >>
> > Sorry, I should have explained better. I will expand here, but feel fre=
e to skip it since we are going to discard the
> > data anyway. Or to propose a better way to tell them.
> >
> > Is a CSV with the values I've obtained, in pps, from pktgen and testpmd=
. This way is easy to plot them.
> >
> > Maybe is easier as tables, if mail readers/gmail does not misalign them=
.
> >

Hi!

Posting here the results varying batch_num with the patch MST proposed.


> >>> # Tx
> >>> # =3D=3D=3D
> > Base: With the previous code, not integrating any patch. testpmd is txo=
nly mode, tap interface is XDP_DROP everything.
> > We vary VHOST_NET_BATCH (1, 16, 32, ...). As Jason put in a previous ma=
il:
> >
> > TX: testpmd(txonly) -> virtio-user -> vhost_net -> XDP_DROP on TAP
> >
> >
> >       1     |     16     |     32     |     64     |     128    |    25=
6     |   512  |
> > 2293304.308| 3396057.769| 3540860.615| 3636056.077| 3332950.846| 369427=
6.154| 3689820|
> >

    -64    |    -63    |    -32    |     0     |     64    |    192    |   =
 448
3493152.154|3495505.462|3494803.692|3492645.692|3501892.154|3496698.846|349=
5192.462

As Michael said, varying VHOST_NET_BATCH affected much more than
varying only the vhost batch_num. Here we see that to vary batch_size
does not affect pps, since we still have not applied the batch patch.

However, performance is worse in pps when we set VHOST_NET_BATCH to a
bigger value. Would this be a good moment to evaluate if we should
increase it?

> > If we add the batching part of the series, but not the bufapi:
> >
> >        1     |     16     |     32     |     64     |     128    |    2=
56    |     512    |
> > 2286723.857 | 3307191.643| 3400346.571| 3452527.786| 3460766.857| 34310=
42.5 | 3440722.286|
> >

    -64    |  -63  |    -32    |    0    |    64     |    192    |    448
3403270.286|3420415|3423424.071|3445849.5|3452552.429|3447267.571|3429406.2=
86

As before, adding the batching patch decreases pps, but by a very
little factor this time.

This makes me think: Is

> > And if we add the bufapi part, i.e., all the series:
> >
> >        1    |     16     |     32     |     64     |     128    |     2=
56    |     512    |    1024
> > 2257970.769| 3151268.385| 3260150.538| 3379383.846| 3424028.846| 343338=
4.308| 3385635.231| 3406554.538
> >

    -64    |    -63    |    -32    |     0     |    64     |  192  |   448
3363233.929|3409874.429|3418717.929|3422728.214|3428160.214|3416061|3428423=
.071

It looks like a small performance decrease again, but by a very tiny factor=
.

> > For easier treatment, all in the same table:
> >
> >       1      |     16      |     32      |      64     |     128     | =
   256      |   512      |    1024
> > ------------+-------------+-------------+-------------+-------------+--=
-----------+------------+------------
> > 2293304.308 | 3396057.769 | 3540860.615 | 3636056.077 | 3332950.846 | 3=
694276.154 | 3689820    |
> > 2286723.857 | 3307191.643 | 3400346.571 | 3452527.786 | 3460766.857 | 3=
431042.5   | 3440722.286|
> > 2257970.769 | 3151268.385 | 3260150.538 | 3379383.846 | 3424028.846 | 3=
433384.308 | 3385635.231| 3406554.538
> >

    -64    |    -63    |    -32    |     0     |     64    |    192    |   =
 448
3493152.154|3495505.462|3494803.692|3492645.692|3501892.154|3496698.846|349=
5192.462
3403270.286|  3420415  |3423424.071| 3445849.5
|3452552.429|3447267.571|3429406.286
3363233.929|3409874.429|3418717.929|3422728.214|3428160.214|  3416061
|3428423.071

> >>> # Rx
> >>> # =3D=3D
> > The rx tests are done with pktgen injecting packets in tap interface, a=
nd testpmd in rxonly forward mode. Again, each
> > column is a different value of VHOST_NET_BATCH, and each row is base, +=
batching, and +buf_api:
> >
> >>> # pktgen results (pps)
> > (Didn't record extreme cases like >512 bufs batching)
> >
> >     1   |   16   |   32   |   64   |   128  |  256   |   512
> > -------+--------+--------+--------+--------+--------+--------
> > 1223275| 1668868| 1728794| 1769261| 1808574| 1837252| 1846436
> > 1456924| 1797901| 1831234| 1868746| 1877508| 1931598| 1936402
> > 1368923| 1719716| 1794373| 1865170| 1884803| 1916021| 1975160
> >

  -64  |  -63  |  -32  |   0   |   64  |  192  |448
1798545|1785760|1788313|1782499|1784369|1788149|1790630
1794057|1837997|1865024|1866864|1890044|1877582|1884620
1804382|1860677|1877419|1885466|1900464|1887813|1896813

Except in the -64 case, buffering and buf_api increase pps rate, more
as more batching is used.

> >>> # Testpmd pps results
> >        1     |     16     |     32     |     64    |    128    |    256=
     |    512     |    1024    |   2048
> > ------------+------------+------------+-----------+-----------+--------=
----+------------+------------+---------
> > 1222698.143 | 1670604    | 1731040.6  | 1769218   | 1811206   | 1839308=
.75 | 1848478.75 |
> > 1450140.5   | 1799985.75 | 1834089.75 | 1871290   | 1880005.5 | 1934147=
.25 | 1939034    |
> > 1370621     | 1721858    | 1796287.75 | 1866618.5 | 1885466.5 | 1918670=
.75 | 1976173.5  | 1988760.75 | 1978316
> >

    -64   |    -63   |    -32   |    0     |    64    |    192   |   448
1799920   |1786848   |1789520.25|1783995.75|1786184.5 |1790263.75|1793109.2=
5
1796374   |1840254   |1867761   |1868076.25|1892006   |1878957.25|1886311
1805797.25|1862528.75|1879510.75|1888218.5 |1902516.25|1889216.25|1899251.2=
5

Same as previous.


> > The last extreme cases (>512 bufs batched) were recorded just for the b=
ufapi case.
> >
> > Does that make sense now?
> >
> > Thanks!
>
>
> I wonder why we saw huge difference between TX and RX pps. Have you used
> samples/pktgen/XXX for doing the test? Maybe you can paste the perf
> record result for the pktgen thread + vhost thread.
>

With the rx base and batch_num=3D0 (i.e., with no modifications):
Overhead  Command     Shared Object     Symbol
  14,40%  vhost-3904  [kernel.vmlinux]  [k] copy_user_generic_unrolled
  12,63%  vhost-3904  [tun]             [k] tun_do_read
  11,70%  vhost-3904  [vhost_net]       [k] vhost_net_buf_peek
   9,77%  vhost-3904  [kernel.vmlinux]  [k] _copy_to_iter
   6,52%  vhost-3904  [vhost_net]       [k] handle_rx
   6,29%  vhost-3904  [vhost]           [k] vhost_get_vq_desc
   4,60%  vhost-3904  [kernel.vmlinux]  [k] __check_object_size
   4,14%  vhost-3904  [kernel.vmlinux]  [k] kmem_cache_free
   4,06%  vhost-3904  [kernel.vmlinux]  [k] iov_iter_advance
   3,10%  vhost-3904  [vhost]           [k] translate_desc
   2,60%  vhost-3904  [kernel.vmlinux]  [k] __virt_addr_valid
   2,53%  vhost-3904  [kernel.vmlinux]  [k] __slab_free
   2,16%  vhost-3904  [tun]             [k] tun_recvmsg
   1,64%  vhost-3904  [kernel.vmlinux]  [k] copy_user_enhanced_fast_string
   1,31%  vhost-3904  [vhost_iotlb]     [k]
vhost_iotlb_itree_subtree_search.part.2
   1,27%  vhost-3904  [kernel.vmlinux]  [k] __skb_datagram_iter
   1,12%  vhost-3904  [kernel.vmlinux]  [k] page_frag_free
   0,92%  vhost-3904  [kernel.vmlinux]  [k] skb_release_data
   0,87%  vhost-3904  [kernel.vmlinux]  [k] skb_copy_datagram_iter
   0,62%  vhost-3904  [kernel.vmlinux]  [k] simple_copy_to_iter
   0,60%  vhost-3904  [kernel.vmlinux]  [k] __free_pages_ok
   0,54%  vhost-3904  [kernel.vmlinux]  [k] skb_release_head_state
   0,53%  vhost-3904  [vhost]           [k] vhost_exceeds_weight
   0,53%  vhost-3904  [kernel.vmlinux]  [k] consume_skb
   0,52%  vhost-3904  [vhost_iotlb]     [k] vhost_iotlb_itree_first
   0,45%  vhost-3904  [vhost]           [k] vhost_signal

With rx in batch, I have a few unknown symbols, but much less
copy_user_generic. Not sure why these symbols are unknown, since they
were recorded using the exact same command. I will try to investigate
more, but here they are meanwhile.

I suspect the top unknown one will be the "cpoy_user_generic_unrolled":
  14,06%  vhost-5127  [tun]             [k] tun_do_read
  12,53%  vhost-5127  [vhost_net]       [k] vhost_net_buf_peek
   6,80%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff852cde46
   6,20%  vhost-5127  [vhost_net]       [k] handle_rx
   5,73%  vhost-5127  [vhost]           [k] fetch_buf
   3,77%  vhost-5127  [vhost]           [k] vhost_get_vq_desc
   2,08%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff852cde6e
   1,82%  vhost-5127  [tun]             [k] tun_recvmsg
   1,37%  vhost-5127  [vhost]           [k] translate_desc
   1,34%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff8510b0a8
   1,32%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff852cdec0
   0,94%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff85291688
   0,84%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff852cde49
   0,79%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff852cde44
   0,67%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff8529167c
   0,66%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff852cde5e
   0,64%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff8510b0b6
   0,59%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff85291663
   0,59%  vhost-5127  [vhost_iotlb]     [k]
vhost_iotlb_itree_subtree_search.part.2
   0,57%  vhost-5127  [kernel.vmlinux]  [k] 0xffffffff852916c0

For tx, here we have the base, with a lot of
copy_user_generic/copy_page_from_iter:
  28,87%  vhost-3095  [kernel.vmlinux]  [k] copy_user_generic_unrolled
  16,34%  vhost-3095  [kernel.vmlinux]  [k] copy_page_from_iter
  11,53%  vhost-3095  [vhost_net]       [k] handle_tx_copy
   7,87%  vhost-3095  [vhost]           [k] vhost_get_vq_desc
   5,42%  vhost-3095  [vhost]           [k] translate_desc
   3,47%  vhost-3095  [kernel.vmlinux]  [k] copy_user_enhanced_fast_string
   3,16%  vhost-3095  [tun]             [k] tun_sendmsg
   2,72%  vhost-3095  [vhost_net]       [k] get_tx_bufs
   2,19%  vhost-3095  [vhost_iotlb]     [k]
vhost_iotlb_itree_subtree_search.part.2
   1,84%  vhost-3095  [kernel.vmlinux]  [k] iov_iter_advance
   1,21%  vhost-3095  [tun]             [k] tun_xdp_act.isra.54
   1,15%  vhost-3095  [kernel.vmlinux]  [k] __netif_receive_skb_core
   1,10%  vhost-3095  [kernel.vmlinux]  [k] kmem_cache_free
   1,08%  vhost-3095  [kernel.vmlinux]  [k] __skb_flow_dissect
   0,93%  vhost-3095  [vhost_iotlb]     [k] vhost_iotlb_itree_first
   0,79%  vhost-3095  [vhost]           [k] vhost_exceeds_weight
   0,72%  vhost-3095  [kernel.vmlinux]  [k] copyin
   0,55%  vhost-3095  [vhost]           [k] vhost_signal

And, again, the batch version with unknown symbols. I expected two of
them (copy_user_generic/copy_page_from_iter), but only one unknown
symbol was found.
  21,40%  vhost-3382  [kernel.vmlinux]  [k] 0xffffffff852cde46
  11,07%  vhost-3382  [vhost_net]       [k] handle_tx_copy
   9,91%  vhost-3382  [vhost]           [k] fetch_buf
   3,81%  vhost-3382  [vhost]           [k] vhost_get_vq_desc
   3,55%  vhost-3382  [kernel.vmlinux]  [k] 0xffffffff852cde6e
   3,10%  vhost-3382  [tun]             [k] tun_sendmsg
   2,64%  vhost-3382  [vhost_net]       [k] get_tx_bufs
   2,26%  vhost-3382  [vhost]           [k] translate_desc

Do you want different reports? I will try to resolve these unknown
symbols, and to generate pktgen reports too.

Thanks!

> Thanks
>
>
> >
>

