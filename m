Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C086F6EAA29
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 14:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjDUMSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 08:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjDUMR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 08:17:59 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5A38A46;
        Fri, 21 Apr 2023 05:17:57 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-555f0997639so1999637b3.0;
        Fri, 21 Apr 2023 05:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682079477; x=1684671477;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PHRVcnws9JLHYb2wrhNrf1jZ5IsjgkEFjyMKPY6FWck=;
        b=rviAZLkZIV57HNRn+L1+3Dd2eKzJHk7dyKa6l6w+g1oAPe4m1MFkhXteATOMJb2btt
         Cb/Jr1m00wKeqUM8vt2yOSESakT6DNaUudhpNmkEkAufqEq+mcgEquZ0ZFHKK/zsbotF
         3GQpLFyJiOv4fM/Erc9+mRJXnvbm6+HHtzeMHqgP8wVQicqZEaggfbzoeXvWaeisrgc9
         +2/soSCmvBY0SYMKEEsOEBi6rXuoqpveqnsJNs5ZJksBZmXQTNh0Iet62EJKT+2OGFW6
         l6MnT1MYIgGrg05Y0yqtMeEP2s8wmfs19pSUs3MKigfO8uSrGEi+65aat7kp/ZivcnD6
         S1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682079477; x=1684671477;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PHRVcnws9JLHYb2wrhNrf1jZ5IsjgkEFjyMKPY6FWck=;
        b=Hrp492agKjUIWzTKcAQsmxDezTQZzYJLcy6U+oowkqJUKBuWqFo1JFfvGBbUdAUOm5
         83s3wCPpv/EYaKUmK2m50A5pvVPar8Xus7uSkyc8KOSrXH6bGN981zsOOFpyuYkId64D
         IaOS9aHcLcsA4A3RvszrkE/CN4kvXkIGRPpcWMx6zFjGyhIfYataqvap/cfTZ5/vaZz2
         CPLpV0l5Bb9Taw5MMULTip/pyIi9el6qIam2FuzhunIHcdlSqqc6yPZ5W6gYKEhPc2yc
         ZpPKUn0X8T64GIBxvuf5zeZBsO40lxUMIhd/WeNmO5HBoZtpIVFaTUcdJOjNFpyX7FrZ
         DytQ==
X-Gm-Message-State: AAQBX9fX3llza+IvA2RrAuPAtOtxal4UweEQuBIw1AV3MOqqbvr+O1d/
        x7YuFpLXQLu5fWng1cvgkfYTj7LWMNSjVHyEn70=
X-Google-Smtp-Source: AKy350YRasU3Zk7MW/yw6YHwoAeIthS7e/jQyPasXKsvsAp+v5Ko4XsCvFg7t4DmatytjcDgKmc52dVbLHLv0r+m3yA=
X-Received: by 2002:a81:1710:0:b0:53c:70c5:45d2 with SMTP id
 16-20020a811710000000b0053c70c545d2mr3252193ywx.0.1682079476830; Fri, 21 Apr
 2023 05:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230406130205.49996-2-kal.conley@dectris.com>
 <87sfdckgaa.fsf@toke.dk> <ZDBEng1KEEG5lOA6@boxer> <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk> <CAHApi-=rMHt7uR8Sw1Vw+MHDrtkyt=jSvTvwz8XKV7SEb01CmQ@mail.gmail.com>
 <87ile011kz.fsf@toke.dk> <CAHApi-=ODe-WtJ=m6bycQhKoQxb+kk2Yk9Fx5SgBsWUuWT_u-A@mail.gmail.com>
 <874jpdwl45.fsf@toke.dk> <CAHApi-kcaMRPj4mEPs87_4Z6iO5qEpzOOcbVza7vxURqCtpz=Q@mail.gmail.com>
 <ZEJZYa8WT6A9VpOJ@boxer>
In-Reply-To: <ZEJZYa8WT6A9VpOJ@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 21 Apr 2023 14:17:45 +0200
Message-ID: <CAJ8uoz39jty9S+=Wjh6RuOseZOjCe3oO1mAHEBGbmT3CA5sHiA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Kal Cutter Conley <kal.conley@dectris.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 at 11:44, Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Apr 18, 2023 at 01:12:00PM +0200, Kal Cutter Conley wrote:
>
> Hi there,
>
> > > >> In addition, presumably when using this mode, the other XDP actions
> > > >> (XDP_PASS, XDP_REDIRECT to other targets) would stop working unless we
> > > >> add special handling for that in the kernel? We'll definitely need to
> > > >> handle that somehow...
> > > >
> > > > I am not familiar with all the details here. Do you know a reason why
> > > > these cases would stop working / why special handling would be needed?
> > > > For example, if I have a UMEM that uses hugepages and XDP_PASS is
> > > > returned, then the data is just copied into an SKB right? SKBs can
> > > > also be created directly from hugepages AFAIK. So I don't understand
> > > > what the issue would be. Can someone explain this concern?
> > >
> > > Well, I was asking :) It may well be that the SKB path just works; did
> > > you test this? Pretty sure XDP_REDIRECT to another device won't, though?
>
> for XDP_PASS we have to allocate a new buffer and copy the contents from
> current xdp_buff that was backed by xsk_buff_pool and give the current one
> back to pool. I am not sure if __napi_alloc_skb() is always capable of
> handling len > PAGE_SIZE - i believe there might a particular combination
> of settings that allows it, but if not we should have a fallback path that
> would iterate over data and copy this to a certain (linear + frags) parts.
> This implies non-zero effort that is needed for jumbo frames ZC support.

Thinking aloud, could not our multi-buffer work help with this? Sounds
quite similar to operations that we have to do in that patch set. And
if so, would it not be prudent to get the multi-buffer support in
there first, then implement these things on top of that? What do you
think?

> I can certainly test this out and play with it - maybe this just works, I
> didn't check yet. Even if it does, then we need some kind of temporary
> mechanism that will forbid loading ZC jumbo frames due to what Toke
> brought up.
>
> > >
> >
> > I was also asking :-)
> >
> > I tested that the SKB path is usable today with this patch.
> > Specifically, sending and receiving large jumbo packets with AF_XDP
> > and that a non-multi-buffer XDP program could access the whole packet.
> > I have not specifically tested XDP_REDIRECT to another device or
> > anything with ZC since that is not possible without driver support.
> >
> > My feeling is, there wouldn't be non-trivial issues here since this
> > patchset changes nothing except allowing the maximum chunk size to be
> > larger. The driver either supports larger MTUs with XDP enabled or it
> > doesn't. If it doesn't, the frames are dropped anyway. Also, chunk
> > size mismatches between two XSKs (e.g. with XDP_REDIRECT) would be
> > something supported or not supported irrespective of this patchset.
>
> Here is the comparison between multi-buffer and jumbo frames that I did
> for ZC ice driver. Configured MTU was 8192 as this is the frame size for
> aligned mode when working with huge pages. I am presenting plain numbers
> over here from xdpsock.
>
> Mbuf, packet size = 8192 - XDP_PACKET_HEADROOM
> 885,705pps - rxdrop frame_size=4096
> 806,307pps - l2fwd frame_size=4096
> 877,989pps - rxdrop frame_size=2048
> 773,331pps - l2fwd frame_size=2048
>
> Jumbo, packet size = 8192 - XDP_PACKET_HEADROOM
> 893,530pps - rxdrop frame_size=8192
> 841,860pps - l2fwd frame_size=8192
>
> Kal might say that multi-buffer numbers are imaginary as these patches
> were never shown to the public ;) but now that we have extensive test
> suite I am fixing some last issues that stand out, so we are asking for
> some more patience over here... overall i was expecting that they will be
> much worse when compared to jumbo frames, but then again i believe this
> implementation is not ideal and can be improved. Nevertheless, jumbo
> frames support has its value.
