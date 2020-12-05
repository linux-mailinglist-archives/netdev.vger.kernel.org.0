Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968642CFDAB
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgLESmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:42:42 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:58357 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727347AbgLEQ5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 11:57:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 8DDBE60E;
        Sat,  5 Dec 2020 10:51:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 05 Dec 2020 10:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=9zd5YnVW5m9n74ywBM5+lZcIQmt
        S/W44ACx+gdsMPgw=; b=Dcdf5/aRZt5/spe1Wli8o9Qi0aEugAOjfXF4CWPyFUW
        zvF8iOwYdP97wv37BATxsHTgr/UJelUV6EifUFUQ/wE1yuyDo1bJiNNZUAGf+ytO
        DCAw7f6OOu0Rjn8GCHUfs7rP/6Zo1Kqx/9zO8vqUzDOTN2Q9e0npCIUhgN+8eNDO
        utWliybb9XhFH/lrnRKZBy1ajXU7SqCGZp2z5sGI9L8qVj3obBCyu8/Vdudb3Cly
        PGkKNlQ0bp6RhWBo1eaiWIgA4Gh3bZF9a8DxhZfTS7OCRxj8BrRQgUqqZT9Q2qex
        pWk8yNVgODQj9j0Lro8+W5/MK5XFzCgp+So2t7CyatQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9zd5Yn
        VW5m9n74ywBM5+lZcIQmtS/W44ACx+gdsMPgw=; b=cuqxtYqiHDIiw4w8QuYQz2
        JLA9e4vScA2joFZ8V9b42FjRPH3abofGkkbkV66axYjVRYSjZ21iR+/3z1oVGTBC
        4+8fqj3kLQgORj+NRZxW3nc0wVUJa6gUTLwX3WqwF8N0LRQjf1GMpuBxlR33W/+5
        N01Fd7NeY8rThZX6QGUuQBUu8u/byUt+l6om44QJuuqks8Kqz7jzn66+AoDKhSoP
        EnrxHbhAkb7fjUWiguoF7Q5OWHanOBmddGZh+6UMBo44BX9jxATb4+fLCok76/lz
        5P5/8Wy6vpZUZsHcOkVynkQK+YtqS/qnmjTfdxJnU6Wepf6orwKV9idpYxq2LmwQ
        ==
X-ME-Sender: <xms:l6zLX9W2Iefkq3KbTfpbKO14GeWL2dT03qVvJxF8ayJnPEl6wtWE9A>
    <xme:l6zLX9lS8D3dzyXAfsWiOXvE7G4MtWkIRPDqZndhXMlT3uqs6UmhV3FS11Qh4KUS7
    r24ueP7j-tbFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejtddgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:l6zLX5aULs9Vjcs0JV9_TZXJSvd_m8-n7zJbhfZcq3-D81SNrjc29w>
    <xmx:l6zLXwV0f2PHaMCNVx8ARTjv_svXGJmJzJtYFM102xYDw_vGLj_H7Q>
    <xmx:l6zLX3moYGa1jCk1Vntn_TdSTFbb0NHKH2StAJ9OItgNCdLSzGXg3A>
    <xmx:mqzLX3NgSqG2bmzPJyssWD9f4cKL_QspmNo_5SIiSuIVO8BQUKEPQRqWY_k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ECAB5108005F;
        Sat,  5 Dec 2020 10:51:50 -0500 (EST)
Date:   Sat, 5 Dec 2020 16:53:06 +0100
From:   Greg KH <greg@kroah.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jmaloy@redhat.com,
        ying.xue@windriver.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 1/7] net: 8021q: remove unneeded MODULE_VERSION() usage
Message-ID: <X8us4vsLCh/tXFLh@kroah.com>
References: <20201202124959.29209-1-info@metux.net>
 <20201205112018.zrddte4hu6kr5bxg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205112018.zrddte4hu6kr5bxg@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 05, 2020 at 01:20:18PM +0200, Vladimir Oltean wrote:
> On Wed, Dec 02, 2020 at 01:49:53PM +0100, Enrico Weigelt, metux IT consult wrote:
> > Remove MODULE_VERSION(), as it isn't needed at all: the only version
> > making sense is the kernel version.
> >
> > Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
> > ---
> >  net/8021q/vlan.c | 8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> >
> > diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> > index f292e0267bb9..683e9e825b9e 100644
> > --- a/net/8021q/vlan.c
> > +++ b/net/8021q/vlan.c
> > @@ -36,15 +36,10 @@
> >  #include "vlan.h"
> >  #include "vlanproc.h"
> >
> > -#define DRV_VERSION "1.8"
> > -
> >  /* Global VLAN variables */
> >
> >  unsigned int vlan_net_id __read_mostly;
> >
> > -const char vlan_fullname[] = "802.1Q VLAN Support";
> > -const char vlan_version[] = DRV_VERSION;
> > -
> >  /* End of global variables definitions. */
> >
> >  static int vlan_group_prealloc_vid(struct vlan_group *vg,
> > @@ -687,7 +682,7 @@ static int __init vlan_proto_init(void)
> >  {
> >  	int err;
> >
> > -	pr_info("%s v%s\n", vlan_fullname, vlan_version);
> > +	pr_info("802.1Q VLAN Support\n");
> 
> How do we feel about deleting this not really informative message
> altogether in a future patch?

It too should be removed.  If drivers are working properly, they are
quiet.
