Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B63C225DB5
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgGTLqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:46:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31591 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728460AbgGTLqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 07:46:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595245557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xVTtZN1yW6PDq/VCwi0KTUBcBexhd/cNJy1JNokh2V4=;
        b=DN0SYjww3CGbaoE+O7aLj7tm5V2tQGDhPUMMd0sBMQuyPe1MVXZSajJmHeQd9OQ47BSm4/
        ifnsVSFrJKDh1FEQs7DYUdhsbokHYEB3mHVWajP80RFh02Bxh2i5Q9ZqElBrltOSJl6Uo9
        PmzlHB3H4NDmS4az843DehP9jiDUiUc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-EV_WLiEGOhicmyIVuXUPMw-1; Mon, 20 Jul 2020 07:45:55 -0400
X-MC-Unique: EV_WLiEGOhicmyIVuXUPMw-1
Received: by mail-wm1-f69.google.com with SMTP id w25so10375143wmc.0
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 04:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xVTtZN1yW6PDq/VCwi0KTUBcBexhd/cNJy1JNokh2V4=;
        b=QKJSDNT6r4cb0DkUkGustbRp1FoB90Rom7zXjuTSudXFqHWiu9vEr8Hi70E//82g/y
         DhWjW+x6CVhYnVElE5l/zl9fpOZqGh1nlxHhKBDPChSJ/hzVU7QsPhcNqGWOmcF5Bjld
         2cp4qzlXDMw2isSn/0K2LZ36GQ0pA+JMTb53Mp9vJMEsqmtBe0nvqDcro9G5cNMwn6Uu
         +kbeS2NLV0zynhRXJEadGJSNWkuRL8Q77OeLZMFoDddRo9P2Zquwa6iwCHcVpOcB96Yn
         +b5hLyeqol+2BcxL875X4Rr4ZR91GNUn7jJTHv1teXB2lgswxmVugOlIbEfa4txTANmv
         09Sw==
X-Gm-Message-State: AOAM531Gmq73Nt62TMiL6NgD3GnKN43KqclWSePGT5XL7f3VBP2ai9cX
        yLA9fMk45GL7Qy1pz3K/CWP6zry7rvyh9r/wdAji/KxxdxYZWThKh9S7lX8vMLnaVgUIhsVWSy7
        cVwwLOH7bYFjnDyIc
X-Received: by 2002:adf:ff8c:: with SMTP id j12mr21608419wrr.230.1595245554054;
        Mon, 20 Jul 2020 04:45:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywUX7LcIswRfFXg4IKadDwW85Nm02WIeN/kLTe6nu60lfJo1MyfmNao5wM684NFhYV4mfY2Q==
X-Received: by 2002:adf:ff8c:: with SMTP id j12mr21608404wrr.230.1595245553799;
        Mon, 20 Jul 2020 04:45:53 -0700 (PDT)
Received: from redhat.com (bzq-79-180-10-140.red.bezeqint.net. [79.180.10.140])
        by smtp.gmail.com with ESMTPSA id o205sm33683152wme.24.2020.07.20.04.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 04:45:52 -0700 (PDT)
Date:   Mon, 20 Jul 2020 07:45:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
Message-ID: <20200720074545-mutt-send-email-mst@kernel.org>
References: <CAJaqyWedEg9TBkH1MxGP1AecYHD-e-=ugJ6XUN+CWb=rQGf49g@mail.gmail.com>
 <0a83aa03-8e3c-1271-82f5-4c07931edea3@redhat.com>
 <CAJaqyWeqF-KjFnXDWXJ2M3Hw3eQeCEE2-7p1KMLmMetMTm22DQ@mail.gmail.com>
 <20200709133438-mutt-send-email-mst@kernel.org>
 <7dec8cc2-152c-83f4-aa45-8ef9c6aca56d@redhat.com>
 <CAJaqyWdLOH2EceTUduKYXCQUUNo1XQ1tLgjYHTBGhtdhBPHn_Q@mail.gmail.com>
 <20200710015615-mutt-send-email-mst@kernel.org>
 <CAJaqyWf1skGxrjuT9GLr6dtgd-433y-rCkbtStLHaAs2W2jYXA@mail.gmail.com>
 <20200720051410-mutt-send-email-mst@kernel.org>
 <d4e29f0451f7551ee3a408ecfa40de2de2b8aa75.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4e29f0451f7551ee3a408ecfa40de2de2b8aa75.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 01:16:47PM +0200, Eugenio Pérez wrote:
> 
> On Mon, Jul 20, 2020 at 11:27 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Thu, Jul 16, 2020 at 07:16:27PM +0200, Eugenio Perez Martin wrote:
> > > On Fri, Jul 10, 2020 at 7:58 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > On Fri, Jul 10, 2020 at 07:39:26AM +0200, Eugenio Perez Martin wrote:
> > > > > > > How about playing with the batch size? Make it a mod parameter instead
> > > > > > > of the hard coded 64, and measure for all values 1 to 64 ...
> > > > > > 
> > > > > > Right, according to the test result, 64 seems to be too aggressive in
> > > > > > the case of TX.
> > > > > > 
> > > > > 
> > > > > Got it, thanks both!
> > > > 
> > > > In particular I wonder whether with batch size 1
> > > > we get same performance as without batching
> > > > (would indicate 64 is too aggressive)
> > > > or not (would indicate one of the code changes
> > > > affects performance in an unexpected way).
> > > > 
> > > > --
> > > > MST
> > > > 
> > > 
> > > Hi!
> > > 
> > > Varying batch_size as drivers/vhost/net.c:VHOST_NET_BATCH,
> > 
> > sorry this is not what I meant.
> > 
> > I mean something like this:
> > 
> > 
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index 0b509be8d7b1..b94680e5721d 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -1279,6 +1279,10 @@ static void handle_rx_net(struct vhost_work *work)
> >         handle_rx(net);
> >  }
> > 
> > +MODULE_PARM_DESC(batch_num, "Number of batched descriptors. (offset from 64)");
> > +module_param(batch_num, int, 0644);
> > +static int batch_num = 0;
> > +
> >  static int vhost_net_open(struct inode *inode, struct file *f)
> >  {
> >         struct vhost_net *n;
> > @@ -1333,7 +1337,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
> >                 vhost_net_buf_init(&n->vqs[i].rxq);
> >         }
> >         vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
> > -                      UIO_MAXIOV + VHOST_NET_BATCH,
> > +                      UIO_MAXIOV + VHOST_NET_BATCH + batch_num,
> >                        VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
> >                        NULL);
> > 
> > 
> > then you can try tweaking batching and playing with mod parameter without
> > recompiling.
> > 
> > 
> > VHOST_NET_BATCH affects lots of other things.
> > 
> 
> Ok, got it. Since they were aligned from the start, I thought it was a good idea to maintain them in-sync.
> 
> > > and testing
> > > the pps as previous mail says. This means that we have either only
> > > vhost_net batching (in base testing, like previously to apply this
> > > patch) or both batching sizes the same.
> > > 
> > > I've checked that vhost process (and pktgen) goes 100% cpu also.
> > > 
> > > For tx: Batching decrements always the performance, in all cases. Not
> > > sure why bufapi made things better the last time.
> > > 
> > > Batching makes improvements until 64 bufs, I see increments of pps but like 1%.
> > > 
> > > For rx: Batching always improves performance. It seems that if we
> > > batch little, bufapi decreases performance, but beyond 64, bufapi is
> > > much better. The bufapi version keeps improving until I set a batching
> > > of 1024. So I guess it is super good to have a bunch of buffers to
> > > receive.
> > > 
> > > Since with this test I cannot disable event_idx or things like that,
> > > what would be the next step for testing?
> > > 
> > > Thanks!
> > > 
> > > --
> > > Results:
> > > # Buf size: 1,16,32,64,128,256,512
> > > 
> > > # Tx
> > > # ===
> > > # Base
> > > 2293304.308,3396057.769,3540860.615,3636056.077,3332950.846,3694276.154,3689820
> > > # Batch
> > > 2286723.857,3307191.643,3400346.571,3452527.786,3460766.857,3431042.5,3440722.286
> > > # Batch + Bufapi
> > > 2257970.769,3151268.385,3260150.538,3379383.846,3424028.846,3433384.308,3385635.231,3406554.538
> > > 
> > > # Rx
> > > # ==
> > > # pktgen results (pps)
> > > 1223275,1668868,1728794,1769261,1808574,1837252,1846436
> > > 1456924,1797901,1831234,1868746,1877508,1931598,1936402
> > > 1368923,1719716,1794373,1865170,1884803,1916021,1975160
> > > 
> > > # Testpmd pps results
> > > 1222698.143,1670604,1731040.6,1769218,1811206,1839308.75,1848478.75
> > > 1450140.5,1799985.75,1834089.75,1871290,1880005.5,1934147.25,1939034
> > > 1370621,1721858,1796287.75,1866618.5,1885466.5,1918670.75,1976173.5,1988760.75,1978316
> > > 
> > > pktgen was run again for rx with 1024 and 2048 buf size, giving
> > > 1988760.75 and 1978316 pps. Testpmd goes the same way.
> > 
> > Don't really understand what does this data mean.
> > Which number of descs is batched for each run?
> > 
> 
> Sorry, I should have explained better. I will expand here, but feel free to skip it since we are going to discard the
> data anyway. Or to propose a better way to tell them.
> 
> Is a CSV with the values I've obtained, in pps, from pktgen and testpmd. This way is easy to plot them.
> 
> Maybe is easier as tables, if mail readers/gmail does not misalign them.
> 
> > > # Tx
> > > # ===
> 
> Base: With the previous code, not integrating any patch. testpmd is txonly mode, tap interface is XDP_DROP everything.
> We vary VHOST_NET_BATCH (1, 16, 32, ...). As Jason put in a previous mail:
> 
> TX: testpmd(txonly) -> virtio-user -> vhost_net -> XDP_DROP on TAP
> 
> 
>      1     |     16     |     32     |     64     |     128    |    256     |   512  |
> 2293304.308| 3396057.769| 3540860.615| 3636056.077| 3332950.846| 3694276.154| 3689820|
> 
> If we add the batching part of the series, but not the bufapi:
> 
>       1     |     16     |     32     |     64     |     128    |    256    |     512    |
> 2286723.857 | 3307191.643| 3400346.571| 3452527.786| 3460766.857| 3431042.5 | 3440722.286|
> 
> And if we add the bufapi part, i.e., all the series:
> 
>       1    |     16     |     32     |     64     |     128    |     256    |     512    |    1024
> 2257970.769| 3151268.385| 3260150.538| 3379383.846| 3424028.846| 3433384.308| 3385635.231| 3406554.538
> 
> For easier treatment, all in the same table:
> 
>      1      |     16      |     32      |      64     |     128     |    256      |   512      |    1024
> ------------+-------------+-------------+-------------+-------------+-------------+------------+------------
> 2293304.308 | 3396057.769 | 3540860.615 | 3636056.077 | 3332950.846 | 3694276.154 | 3689820    |
> 2286723.857 | 3307191.643 | 3400346.571 | 3452527.786 | 3460766.857 | 3431042.5   | 3440722.286|
> 2257970.769 | 3151268.385 | 3260150.538 | 3379383.846 | 3424028.846 | 3433384.308 | 3385635.231| 3406554.538
>  
> > > # Rx
> > > # ==
> 
> The rx tests are done with pktgen injecting packets in tap interface, and testpmd in rxonly forward mode. Again, each
> column is a different value of VHOST_NET_BATCH, and each row is base, +batching, and +buf_api:
> 
> > > # pktgen results (pps)
> 
> (Didn't record extreme cases like >512 bufs batching)
> 
>    1   |   16   |   32   |   64   |   128  |  256   |   512
> -------+--------+--------+--------+--------+--------+--------
> 1223275| 1668868| 1728794| 1769261| 1808574| 1837252| 1846436
> 1456924| 1797901| 1831234| 1868746| 1877508| 1931598| 1936402
> 1368923| 1719716| 1794373| 1865170| 1884803| 1916021| 1975160
> 
> > > # Testpmd pps results
> 
>       1     |     16     |     32     |     64    |    128    |    256     |    512     |    1024    |   2048
> ------------+------------+------------+-----------+-----------+------------+------------+------------+---------
> 1222698.143 | 1670604    | 1731040.6  | 1769218   | 1811206   | 1839308.75 | 1848478.75 |
> 1450140.5   | 1799985.75 | 1834089.75 | 1871290   | 1880005.5 | 1934147.25 | 1939034    |
> 1370621     | 1721858    | 1796287.75 | 1866618.5 | 1885466.5 | 1918670.75 | 1976173.5  | 1988760.75 | 1978316
> 
> The last extreme cases (>512 bufs batched) were recorded just for the bufapi case.
> 
> Does that make sense now?
> 
> Thanks!

yes, thanks!

