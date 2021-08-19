Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C643F16BC
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 11:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237834AbhHSJxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 05:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237543AbhHSJxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 05:53:07 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61E5C061575;
        Thu, 19 Aug 2021 02:52:31 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c17so3621929plz.2;
        Thu, 19 Aug 2021 02:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MtX3zfkwXjgZQmvG0rh2e9cIM28vvI+IW/MYmEHnn/g=;
        b=LYVd7+spnMM/0LWG4s85cvDd2nW2HgTfSitRafnJg9uow2ho3eqiGjfbUz9hC84fyx
         28bOtfIIw/UXBZJnBmVnIAe95XnqpbBSlmMS6D02rRidiCs3xdFbSsR7MGblu8FO+IfG
         3pDxnrlyfLntKd6WEhHbOLpTdJT72BPTSwcs5XwvDbPzV8MJhmJCCToGzyts7bqwA4HK
         2rPg7pCeklMWcYZamB6LAr/GA8iTIfnpoyFpOigilDHZgseKgS8xlEwqA+1TQtvg7miX
         KLflhCPlgvZjarkIsVc8T60r6mtXJB9wkw40F0ryzXIBlFxLYNLjUXx9B+BUMlh4UIRj
         MtUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MtX3zfkwXjgZQmvG0rh2e9cIM28vvI+IW/MYmEHnn/g=;
        b=RgaGrxsE5gLVj+XeexA5I3KLpxBHkiv1Vbtg4pLvkARGTAj/1oltnX8Erg1CMnrAIP
         N+v3iAu951iGVLBVJieCiSSz2mpC8HksEnECiuS3ZwPXza4sQXroLpCKKmr94QbT+wZP
         q0Yj23yXHEMdX0TNqZgZ5TyPdJ+gbDpgNhEOdz5/QBTN97oV2VWVQyWPpHNHKZmftlpR
         1bhq5hW3ovMFHO2SB2uu5SkdSCeDadysp1z5GPvVQLDGnZiCisbNhMfGoxH93CRHWPPJ
         XbJ2qAn8NYPwtqMWfVJQl0GahsCGQilJeWEqoDZmnNSGGvjf5hG0WW+LTTXa2UBHWCgN
         zCfQ==
X-Gm-Message-State: AOAM532tWTrycUWDP1fCc2VpFl51RvIx/blbFghHYFB/+xUPTDOWatxa
        9IsDMfckhlNXKLbap6D+c0VPOziaT8pzcA1WpkA=
X-Google-Smtp-Source: ABdhPJxmBy4Cguct7mmL7MQTi9YV9a75Akl7f3g5y4ppTVad0Fp31wEzXxx0NFgYP6DGiP0FMnlprTTnDwyGfZ26pd4=
X-Received: by 2002:a17:90b:18f:: with SMTP id t15mr13935469pjs.168.1629366751349;
 Thu, 19 Aug 2021 02:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
 <20210817092729.433-11-magnus.karlsson@gmail.com> <20210819092634.GA32204@ranger.igk.intel.com>
In-Reply-To: <20210819092634.GA32204@ranger.igk.intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 19 Aug 2021 11:52:20 +0200
Message-ID: <CAJ8uoz2aUnsnN5TQ5JstfbzByq80yX9utzbt3THwMKFHpYs4zA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 10/16] selftests: xsk: validate tx stats on tx thread
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 11:41 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Aug 17, 2021 at 11:27:23AM +0200, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Validate the tx stats on the Tx thread instead of the Rx
> > tread. Depending on your settings, you might not be allowed to query
> > the statistics of a socket you do not own, so better to do this on the
> > correct thread to start with.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/testing/selftests/bpf/xdpxceiver.c | 55 ++++++++++++++++++------
> >  1 file changed, 41 insertions(+), 14 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> > index fe3d281a0575..8ff24472ef1e 100644
> > --- a/tools/testing/selftests/bpf/xdpxceiver.c
> > +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> > @@ -642,23 +642,22 @@ static void tx_only_all(struct ifobject *ifobject)
> >       complete_tx_only_all(ifobject);
> >  }
> >
> > -static void stats_validate(struct ifobject *ifobject)
> > +static bool rx_stats_are_valid(struct ifobject *ifobject)
> >  {
> > +     u32 xsk_stat = 0, expected_stat = opt_pkt_count;
> > +     struct xsk_socket *xsk = ifobject->xsk->xsk;
> > +     int fd = xsk_socket__fd(xsk);
> >       struct xdp_statistics stats;
> >       socklen_t optlen;
> >       int err;
> > -     struct xsk_socket *xsk = stat_test_type == STAT_TEST_TX_INVALID ?
> > -                                                     ifdict[!ifobject->ifdict_index]->xsk->xsk :
> > -                                                     ifobject->xsk->xsk;
> > -     int fd = xsk_socket__fd(xsk);
> > -     unsigned long xsk_stat = 0, expected_stat = opt_pkt_count;
> > -
> > -     sigvar = 0;
> >
> >       optlen = sizeof(stats);
> >       err = getsockopt(fd, SOL_XDP, XDP_STATISTICS, &stats, &optlen);
> > -     if (err)
> > -             return;
> > +     if (err) {
> > +             ksft_test_result_fail("ERROR: [%s] getsockopt(XDP_STATISTICS) error %u %s\n",
> > +                                   __func__, -err, strerror(-err));
> > +             return true;
>
> Can we invert the logic or change the name of the func?
> Returning 'true' for error case is a bit confusing given the name of func
> is blah_are_valid, no? If there was an error then I'd return false.
>
> OTOH we're testing faulty socket situations in here, but error from
> getsockopt does not mean that stats were valid.

Yes, this is not that clear. We want the loop on the higher level to
quit, therefore we return true when there is an error. A problem with
the stats tests is that they do not terminate when the stats are
wrong, only when they pass. Once I get the second patch set accepted
(in some form), we should rewrite these stats tests in that new
framework so that they will terminate even when the stats are wrong.
This whole problem will likely disappear at that point. But I will
scratch my head and try to make it better in this patch.

> > +     }
> >
> >       if (optlen == sizeof(struct xdp_statistics)) {
> >               switch (stat_test_type) {
> > @@ -666,8 +665,7 @@ static void stats_validate(struct ifobject *ifobject)
> >                       xsk_stat = stats.rx_dropped;
> >                       break;
> >               case STAT_TEST_TX_INVALID:
> > -                     xsk_stat = stats.tx_invalid_descs;
> > -                     break;
> > +                     return true;
> >               case STAT_TEST_RX_FULL:
> >                       xsk_stat = stats.rx_ring_full;
> >                       expected_stat -= RX_FULL_RXQSIZE;
> > @@ -680,8 +678,33 @@ static void stats_validate(struct ifobject *ifobject)
> >               }
> >
> >               if (xsk_stat == expected_stat)
> > -                     sigvar = 1;
> > +                     return true;
> > +     }
> > +
> > +     return false;
> > +}
> > +
> > +static void tx_stats_validate(struct ifobject *ifobject)
> > +{
> > +     struct xsk_socket *xsk = ifobject->xsk->xsk;
> > +     int fd = xsk_socket__fd(xsk);
> > +     struct xdp_statistics stats;
> > +     socklen_t optlen;
> > +     int err;
> > +
> > +     optlen = sizeof(stats);
> > +     err = getsockopt(fd, SOL_XDP, XDP_STATISTICS, &stats, &optlen);
> > +     if (err) {
> > +             ksft_test_result_fail("ERROR: [%s] getsockopt(XDP_STATISTICS) error %u %s\n",
> > +                                   __func__, -err, strerror(-err));
> > +             return;
> >       }
> > +
> > +     if (stats.tx_invalid_descs == opt_pkt_count)
> > +             return;
> > +
> > +     ksft_test_result_fail("ERROR: [%s] tx_invalid_descs incorrect. Got [%u] expected [%u]\n",
> > +                           __func__, stats.tx_invalid_descs, opt_pkt_count);
> >  }
> >
> >  static void thread_common_ops(struct ifobject *ifobject, void *bufs)
> > @@ -767,6 +790,9 @@ static void *worker_testapp_validate_tx(void *arg)
> >       print_verbose("Sending %d packets on interface %s\n", opt_pkt_count, ifobject->ifname);
> >       tx_only_all(ifobject);
> >
> > +     if (stat_test_type == STAT_TEST_TX_INVALID)
> > +             tx_stats_validate(ifobject);
> > +
> >       testapp_cleanup_xsk_res(ifobject);
> >       pthread_exit(NULL);
> >  }
> > @@ -792,7 +818,8 @@ static void *worker_testapp_validate_rx(void *arg)
> >               if (test_type != TEST_TYPE_STATS) {
> >                       rx_pkt(ifobject->xsk, fds);
> >               } else {
> > -                     stats_validate(ifobject);
> > +                     if (rx_stats_are_valid(ifobject))
> > +                             break;
> >               }
> >               if (sigvar)
> >                       break;
> > --
> > 2.29.0
> >
