Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694CF6D43AE
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjDCLi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjDCLi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:38:56 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F43910C1;
        Mon,  3 Apr 2023 04:38:54 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id p204so34332952ybc.12;
        Mon, 03 Apr 2023 04:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680521933;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7f0JvRPA8wF7JzRYt6f8kMcRYqhWRK+NhWeg+hJVnW4=;
        b=Ka0lWqI1eu/HBbFcHQGar8so4yqKR67TH67iGvKwgJB8uUwinZA9ilpZvi2kNAf5Sa
         r/tb0/Rj/RymkZTVOO2TkbIKzXk1Aqc9TRqSC1VhwD9ud013Xzp2E5DTctiC6y7pxsJW
         2ltlrT3K0OSAff7hSc84fdb2flKQ+Em76VL0iKroH4+KCNEG0vg2nkooE7Q8WAOxzIYv
         +h+/vZlUMXa3cZyQSXO6qze7bIJ+z69SCFSb3esun3JBPiyWj+SnC1389bU/VBRpkqWu
         Un+0MOZj/sP4A4n77L2sXwZbsgH1bGyFuJg10+fTx/NfpgJHDIVdh6oxXV+dOLQlxJ1X
         OKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680521933;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7f0JvRPA8wF7JzRYt6f8kMcRYqhWRK+NhWeg+hJVnW4=;
        b=gIl5YhfV9CG0ovtEh+hFKbYwU2EmWui17wEfVcqECVOXiDNVlJe8+TPAFN/ld3RHwC
         mC8URoHfKP9V4M4YC/gxKy+Qkm5I8DmcXH+yDGIvmkFcX5wCJRapkBIuYgEPkLe8PatI
         OV+7See+4IQlM+fuHe7uK5H8Gfo0AZZk+jBQ95SXkdGtldsjjJM8lPnII6LI/SxXQEPr
         PLr4hA4XfMq77OVZ9Gl9kjmzDJNH9t0aC8D2/6bFegOGkJo4GJv0cdLh1YgAE0tQTZw6
         VjgmgNnCbmIwxnJgdkWUzgTie9bF+dT58l0sIQm0o/QZYq+6hcYZhTrKNzyhHKypRDDE
         t3ZA==
X-Gm-Message-State: AAQBX9duGIUiJNwE2t+Q7z/mAocEm79plTZn8nBTyi3K/eZTnzaGVHQ3
        f7VvYHVUeMr+X/MpBQD8RsOEuV3DjJG7qCXW+0Q=
X-Google-Smtp-Source: AKy350ZZshnb2hcPSa2L56dn8KrsJ1ojlCmyoSN4WB8v1sen1WfH2fMzlVaeRaI5cLIr6NXEskGzd55CIOvQwuETEf8=
X-Received: by 2002:a25:cf8e:0:b0:b6a:2590:6c63 with SMTP id
 f136-20020a25cf8e000000b00b6a25906c63mr10856403ybg.2.1680521933188; Mon, 03
 Apr 2023 04:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230329180502.1884307-1-kal.conley@dectris.com>
 <20230329180502.1884307-5-kal.conley@dectris.com> <CAJ8uoz1cGV1_3HQQddbkExVnm=wngP3ECJZNS5gOtQtfi=mPnA@mail.gmail.com>
 <CAHApi-kV_c-z1zf9M_XyR_Wa=4xi-Cpk1FZT7BFTYQHgU1Bdqg@mail.gmail.com> <CAHApi-mp7ymJ2MP_MFK=Rcv--YCz4aqtKArMwF1roRZHh0to1A@mail.gmail.com>
In-Reply-To: <CAHApi-mp7ymJ2MP_MFK=Rcv--YCz4aqtKArMwF1roRZHh0to1A@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 3 Apr 2023 13:38:42 +0200
Message-ID: <CAJ8uoz25jnBtaKZQ7SbJ_fdihiQTfN_AAtOuB4v-g85SS7QM5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/10] selftests: xsk: Deflakify
 STATS_RX_DROPPED test
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 at 13:35, Kal Cutter Conley <kal.conley@dectris.com> wrote:
>
> >
> > Can I send patches 01-05 all together as one patchset?
> >
> On second thought, I will just send out 01, 04, and 05 already
> separately since those are all completely independent.

#2 is also a bug fix in my mind, but not #3 as it just adds a test.

For some reason I did not receive patch #1 and #8. Might be something
flaky on my side, do not know.
