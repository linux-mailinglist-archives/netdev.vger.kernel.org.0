Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F9365C9B6
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjACWfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbjACWfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:35:43 -0500
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03B92BFE;
        Tue,  3 Jan 2023 14:35:42 -0800 (PST)
Received: by mail-qv1-f53.google.com with SMTP id t13so16495944qvp.9;
        Tue, 03 Jan 2023 14:35:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NL6C9QSnwD/h2JAvk9Oq/i2/KLbEVi58KRA8l/TSh7k=;
        b=2RNIsIaySGnRfukXUxQV9oDLu+hPSt2wX7jw2bH0YwX9Zu6Gm45rOoJE/ZdWoCOJmg
         j887IezmBX+db6Z2VI71+ZT0fHDCXcltR6E6ZPdKPJYf35dHf++qNw1P7Beus74R4a9W
         sIlJxeP8FKTgvilzSqxZD95hNbFF3cLmKFYdsdfklvInEOeLRhy3TSZ2co9kOuF4bC/r
         G8eB+EGp/BSZP6wDYZAV35nvfytZgzqttaM4dzkUyB8hZW3VIcFkBWXJ4zbGx0SjfsTf
         nq0+spJEfok7Q3hcqge2x77aaHvb0kYBE2Z5kg/mrKx2jebCQE8g880tG7QsMdfT4hEf
         Lyew==
X-Gm-Message-State: AFqh2krUIAmx5h5gFQ9mub7+EnEhxbGranxG7QdKRvotiFXssTb5dr2/
        8OORj3LPYoDUHZcBsBRm3DM=
X-Google-Smtp-Source: AMrXdXt3Fs5IX6BBC5vBxy+FnOUCncQTH3qM+ePZwc24UelHUHwd3waQ2jC5NgYZb+tgbd9GzqP6CQ==
X-Received: by 2002:a0c:ef03:0:b0:530:e35d:8e82 with SMTP id t3-20020a0cef03000000b00530e35d8e82mr55664707qvr.9.1672785341619;
        Tue, 03 Jan 2023 14:35:41 -0800 (PST)
Received: from maniforge.lan ([2620:10d:c091:480::1:7c6c])
        by smtp.gmail.com with ESMTPSA id ay34-20020a05620a17a200b006b929a56a2bsm22847066qkb.3.2023.01.03.14.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 14:35:41 -0800 (PST)
Date:   Tue, 3 Jan 2023 16:35:40 -0600
From:   David Vernet <void@manifault.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 07/17] bpf: XDP metadata RX kfuncs
Message-ID: <Y7StvH5gtm8O9KLa@maniforge.lan>
References: <20221220222043.3348718-1-sdf@google.com>
 <20221220222043.3348718-8-sdf@google.com>
 <Y6tWrtltKfAlo0rT@maniforge.lan>
 <CAKH8qBseZ_ceu1A4Cyt_NND9ZcFRapu-74CugPYBfooppXF3xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBseZ_ceu1A4Cyt_NND9ZcFRapu-74CugPYBfooppXF3xA@mail.gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 02:23:59PM -0800, Stanislav Fomichev wrote:
> On Tue, Dec 27, 2022 at 12:33 PM David Vernet <void@manifault.com> wrote:
> >
> > On Tue, Dec 20, 2022 at 02:20:33PM -0800, Stanislav Fomichev wrote:
> >
> > Hey Stanislav,
> >
> > [...]
> >
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index aad12a179e54..b41d18490595 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -74,6 +74,7 @@ struct udp_tunnel_nic_info;
> > >  struct udp_tunnel_nic;
> > >  struct bpf_prog;
> > >  struct xdp_buff;
> > > +struct xdp_md;
> > >
> > >  void synchronize_net(void);
> > >  void netdev_set_default_ethtool_ops(struct net_device *dev,
> > > @@ -1618,6 +1619,11 @@ struct net_device_ops {
> > >                                                 bool cycles);
> > >  };
> > >
> > > +struct xdp_metadata_ops {
> > > +     int     (*xmo_rx_timestamp)(const struct xdp_md *ctx, u64 *timestamp);
> > > +     int     (*xmo_rx_hash)(const struct xdp_md *ctx, u32 *hash);
> > > +};
> > > +
> > >  /**
> > >   * enum netdev_priv_flags - &struct net_device priv_flags
> > >   *
> > > @@ -2050,6 +2056,7 @@ struct net_device {
> > >       unsigned int            flags;
> > >       unsigned long long      priv_flags;
> > >       const struct net_device_ops *netdev_ops;
> > > +     const struct xdp_metadata_ops *xdp_metadata_ops;
> >
> > You need to document this field above the struct, or the docs build will
> > complain:
> >
> >   SPHINX  htmldocs -->
> >   <redacted>
> >   make[2]: Nothing to be done for 'html'.
> >   Using sphinx_rtd_theme theme
> >   source directory: networking
> >   ./include/linux/netdevice.h:2371: warning: Function parameter or
> >   member 'xdp_metadata_ops' not described in 'net_device'
> >
> > >       int                     ifindex;
> > >       unsigned short          gflags;
> > >       unsigned short          hard_header_len;
> 
> Thanks, I will try to actually build the doc. Last time I tried it
> took too long and I gave up :-)

FYI the docs build system supports building specific subdirectories,
e.g.:

make -j SPHINXDIRS="networking" htmldocs

That should take O(seconds) instead of O(timeout) :-)

- David
