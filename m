Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F11D61784A5
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 22:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbgCCVKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 16:10:55 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:39188 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730925AbgCCVKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 16:10:54 -0500
Received: by mail-yw1-f65.google.com with SMTP id x184so105648ywd.6
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 13:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jhw2/hBTqqb08+XbLqFc1lQG7+XacrKgacG+f+lhHlw=;
        b=UuswdbwtGUq/KOpTGPSUcHmuRFxUeMPpUUcP4c3+mgsuAAZ1wqfnSivQRMp7zhqP2i
         yvBWIw6bqMhNA/DPbB71aQ0wCjAsjDNSGE4vvK+62X9DlD438J/f+Nj2df/aPLkpKMfF
         5ocn7OG+YEKPkfrWpPgr+GcwXyvyAQ/mWC5rmoLddKOt9BLvUI7SMHMb7Fw9CVC1Brwp
         7oBlwlgyME+tIP2gNltFHprtxkzqmd46EM7RAj60QXtKXqz8qLiEzu7thzKr+f14dQCa
         wqB5jjXoBB8PCTZRigPCyuFoqbQRvn1jgnb6lYeX9vn9ADIMgGrH9qfcDDR7AZ4WBOg6
         zscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jhw2/hBTqqb08+XbLqFc1lQG7+XacrKgacG+f+lhHlw=;
        b=NHvcU4OiPq6Yy2wud5swcqNWnWXnKfe4W//D8FNg3ry10ppyVS4zqJHKaZ3pQkY8he
         bJRDu6DhxzISVyJsWsCk0rpd9YgX7s4Hzd733NKmDdoly/VW3Fs37l9noRP7ha1FGIp3
         rdF6+9xznCYgrfU/1VXu1XaLZdfXFcIBn7SlgnkeWGWlTEoJQh8im0sA7mZrvtIq+uwS
         2721W8larr9gL37wTTGdV3rDDU2QV6YCHmrJw2z1qkNhuX0nLr2O/5Pa90iW40+FDdSu
         QxoM57PTpJayUXlZAui/m2KNUj62awOT1gDXCGYBOzRtRGm0393TRt79F1+NnZ6KVw26
         +txA==
X-Gm-Message-State: ANhLgQ3V/BK+dmXSgtj8pYPY2Crcz8RI+i6QQLpLnbpGoDC8hEopzwCh
        3BV9vD21sHU0xQh8QoLbmKc1/MgC
X-Google-Smtp-Source: ADFU+vsahuJLpW0gZpVOra6yeOv8gQg/URQ2/J0e1qvdHKbm9kAAthXCwyVXrnuZU5WOFD03VDZtnQ==
X-Received: by 2002:a5b:8c2:: with SMTP id w2mr5951145ybq.415.1583269853128;
        Tue, 03 Mar 2020 13:10:53 -0800 (PST)
Received: from mail-yw1-f52.google.com (mail-yw1-f52.google.com. [209.85.161.52])
        by smtp.gmail.com with ESMTPSA id k195sm2521893ywk.104.2020.03.03.13.10.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 13:10:52 -0800 (PST)
Received: by mail-yw1-f52.google.com with SMTP id a132so134908ywb.2
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 13:10:51 -0800 (PST)
X-Received: by 2002:a0d:d68d:: with SMTP id y135mr2472118ywd.117.1583269851243;
 Tue, 03 Mar 2020 13:10:51 -0800 (PST)
MIME-Version: 1.0
References: <20200228105435.75298-1-lrizzo@google.com> <20200228110043.2771fddb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTSfd80pZroxtqZDsTeEz4FaronC=pdgjeaBBfYqqi5HiyQ@mail.gmail.com>
 <3c27d9c0-eb17-b20f-2d10-01f3bdf8c0d6@iogearbox.net> <20200303125020.2baef01b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200303125020.2baef01b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 3 Mar 2020 16:10:14 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeL_psqzpB6hxSh6f1HnO_SrpED=71Y3HcyDweG2Y3sdg@mail.gmail.com>
Message-ID: <CA+FuTSeL_psqzpB6hxSh6f1HnO_SrpED=71Y3HcyDweG2Y3sdg@mail.gmail.com>
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb linearization
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Luigi Rizzo <lrizzo@google.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>, hawk@kernel.org,
        "Jubran, Samih" <sameehj@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 3, 2020 at 3:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 3 Mar 2020 20:46:55 +0100 Daniel Borkmann wrote:
> > Thus, when the data/data_end test fails in generic XDP, the user can
> > call e.g. bpf_xdp_pull_data(xdp, 64) to make sure we pull in as much as
> > is needed w/o full linearization and once done the data/data_end can be
> > repeated to proceed. Native XDP will leave xdp->rxq->skb as NULL, but
> > later we could perhaps reuse the same bpf_xdp_pull_data() helper for
> > native with skb-less backing. Thoughts?

Something akin to pskb_may_pull sounds like a great solution to me.

Another approach would be a new xdp_action XDP_NEED_LINEARIZED that
causes the program to be restarted after linearization. But that is both
more expensive and less elegant.

Instead of a sysctl or device option, is this an optimization that
could be taken based on the program? Specifically, would XDP_FLAGS be
a path to pass a SUPPORT_SG flag along with the program? I'm not
entirely familiar with the XDP setup code, so this may be a totally
off. But from a quick read it seems like generic_xdp_install could
transfer such a flag to struct net_device.

> I'm curious why we consider a xdpgeneric-only addition. Is attaching
> a cls_bpf program noticeably slower than xdpgeneric?

This just should not be xdp*generic* only, but allow us to use any XDP
with large MTU sizes and without having to disable GRO. I'd still like a
way to be able to drop or modify packets before GRO, or to signal that
a type of packet should skip GRO.
