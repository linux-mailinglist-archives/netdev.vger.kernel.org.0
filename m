Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4E1283F3A
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgJETBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbgJETBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 15:01:19 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3648C0613CE;
        Mon,  5 Oct 2020 12:01:18 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q63so13207748qkf.3;
        Mon, 05 Oct 2020 12:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sRcdP6mMRIN2azjRHcAmgUX6oVyrHsuYRFmR/8uu+aI=;
        b=QRU3KtuV80CCOCGmwH3GsxrhX3DkBlEc9HLmhtRRUaWe7+SY5jc8034jvxt35zrDRB
         xBgrM2KBHIJA77KYLn6JdFo6kEZia5k4MarWHs9ibTHSXbhXQspv6zzFAUqiSbzQ93sr
         1apE56URlfRdBuNm3G1s0DLlgeUYE4FWqoOm1uvnGyg3AoEQtJ9zDifG9NSBwKkdQLLI
         tYilLgauAAaPBkgDwq1cVWShVNhZzfZNQoIm09BZaYggz/+YE+uW5V5hMcqfcCuZo6rK
         kUOi5nK8cC3oPjDVkQSEA9BY5iFowZdtV/X258xgaxiOe3TX/ps9vWnv6IYnLh73fxAY
         QtdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sRcdP6mMRIN2azjRHcAmgUX6oVyrHsuYRFmR/8uu+aI=;
        b=DRY1JqBzO+gOt0UuInCcbRvhJ8XqmfOz+MKGcf2ON6ld1aW4aXoKEOSqoepeMHzFD+
         ccldYH/OwuWb9v6gVgRFwkeWCPYPURN2b81rAPd9rfPmIA2mZhb0E0BqzjCCHrBAlZ0u
         9DUc4Wf6BLUujJpoiKX1kxSfzHoy6h2fBv4sWM4Qp6JXWm2O1PH7BOyuY9DlwmykTSWH
         ugI0XycswMCLOoU2xg28p2XYAHZFfXpe6VrYBXavqP703E7VL/9rCMmd8jl4vwvpIOEK
         apsyuT8QQUTlcmKE6Fz8whStUuE5C2s79c+GCZd4sxqoOaYtkSHLbg4q62thUJxrPe4N
         oiPw==
X-Gm-Message-State: AOAM531WNB5gHUkg3w1Efn3rQKv7KzgK+di6V0ty9YiYVwIIpHFkEFjn
        +pvh8VWM4du2ZUVgNZB8ukM=
X-Google-Smtp-Source: ABdhPJxgqo2sgYZqAe3s1oYciV7YyilMx8K2ivm1zUmOTiVAbweCrK2g4GMZjqqMk8Mcka6Qey/blw==
X-Received: by 2002:a37:4a57:: with SMTP id x84mr1495252qka.17.1601924477996;
        Mon, 05 Oct 2020 12:01:17 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.121])
        by smtp.gmail.com with ESMTPSA id h4sm655782qkl.130.2020.10.05.12.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 12:01:17 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4B5E5C619C; Mon,  5 Oct 2020 16:01:14 -0300 (-03)
Date:   Mon, 5 Oct 2020 16:01:14 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     kernel test robot <lkp@intel.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, kbuild-all@lists.01.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        davem <davem@davemloft.net>
Subject: Re: [PATCH net-next 11/15] sctp: add udphdr to overhead when
 udp_port is set
Message-ID: <20201005190114.GL70998@localhost.localdomain>
References: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <202009300218.2AcHEN0L-lkp@intel.com>
 <20201003040824.GG70998@localhost.localdomain>
 <CADvbK_cPX1f5jrGsKuvya7ssOFPTsG7daBCkOP-NGN9hpzf5Vw@mail.gmail.com>
 <CADvbK_eXnzjDCypRkep9JqxBFV=cMXNkSZr4nyAaMiDc1VGXJg@mail.gmail.com>
 <CADvbK_fzASk9dLbHLNtLLc+uS7hLz6nDi2CESgN55Yh-o92+rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_fzASk9dLbHLNtLLc+uS7hLz6nDi2CESgN55Yh-o92+rQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 08:24:34PM +0800, Xin Long wrote:
> On Sat, Oct 3, 2020 at 7:23 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Sat, Oct 3, 2020 at 4:12 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Sat, Oct 3, 2020 at 12:08 PM Marcelo Ricardo Leitner
> > > <marcelo.leitner@gmail.com> wrote:
> > > >
> > > > On Wed, Sep 30, 2020 at 03:00:42AM +0800, kernel test robot wrote:
> > > > > Hi Xin,
> > > > >
> > > > > Thank you for the patch! Yet something to improve:
> > > >
> > > > I wonder how are you planning to fix this. It is quite entangled.
> > > > This is not performance critical. Maybe the cleanest way out is to
> > > > move it to a .c file.
> > > >
> > > > Adding a
> > > > #if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
> > > > in there doesn't seem good.
> > > >
> > > > >    In file included from include/net/sctp/checksum.h:27,
> > > > >                     from net/netfilter/nf_nat_proto.c:16:
> > > > >    include/net/sctp/sctp.h: In function 'sctp_mtu_payload':
> > > > > >> include/net/sctp/sctp.h:583:31: error: 'struct net' has no member named 'sctp'; did you mean 'ct'?
> > > > >      583 |   if (sock_net(&sp->inet.sk)->sctp.udp_port)
> > > > >          |                               ^~~~
> > > > >          |                               ct
> > > > >
> > > Here is actually another problem, I'm still thinking how to fix it.
> > >
> > > Now sctp_mtu_payload() returns different value depending on
> > > net->sctp.udp_port. but net->sctp.udp_port can be changed by
> > > "sysctl -w" anytime. so:

Good point.

> > >
> > > In sctp_packet_config() it gets overhead/headroom by calling
> > > sctp_mtu_payload(). When 'udp_port' is 0, it's IP+MAC header
> > > size. Then if 'udp_port' is changed to 9899 by 'sysctl -w',
> > > udphdr will also be added to the packet in sctp_v4_xmit(),
> > > and later the headroom may not be enough for IP+MAC headers.
> > >
> > > I'm thinking to add sctp_sock->udp_port, and it'll be set when
> > > the sock is created with net->udp_port. but not sure if we should
> > > update sctp_sock->udp_port with  net->udp_port when sending packets?

I don't think so,

> > something like:
...
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 6614c9fdc51e..c96b13ec72f4 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -91,6 +91,14 @@ void sctp_packet_config(struct sctp_packet *packet,
> __u32 vtag,
>         if (asoc) {
>                 sk = asoc->base.sk;
>                 sp = sctp_sk(sk);
> +
> +               if (unlikely(sp->udp_port != sock_net(sk)->sctp.udp_port)) {

RFC6951 has:

6.1.  Get or Set the Remote UDP Encapsulation Port Number
      (SCTP_REMOTE_UDP_ENCAPS_PORT)
...
   sue_assoc_id:  This parameter is ignored for one-to-one style
      sockets.  For one-to-many style sockets, the application may fill
      in an association identifier or SCTP_FUTURE_ASSOC for this query.
      It is an error to use SCTP_{CURRENT|ALL}_ASSOC in sue_assoc_id.

   sue_address:  This specifies which address is of interest.  If a
      wildcard address is provided, it applies only to future paths.

So I'm not seeing a reason to have a system wide knob that takes
effect in run time like this.
Enable, start apps, and they keep behaving as initially configured.
Need to disable? Restart the apps/sockets.

Thoughts?

> +                       __u16 port = sock_net(sk)->sctp.udp_port;
> +
> +                       if (!sp->udp_port || !port)
> +                               sctp_assoc_update_frag_point(asoc);
> +                       sp->udp_port = port;
> +               }
>         }
