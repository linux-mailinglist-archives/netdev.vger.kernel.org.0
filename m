Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEB76699AC
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241136AbjAMOOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241953AbjAMONi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:13:38 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B933111A
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:11:18 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-4c24993965eso279384787b3.12
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JwcxadUTLm+g1Gzi28tJFADhls3BhprCF3ZKHMeFB8c=;
        b=m6dHHWEKsz5t/1GMM+CGtO+3mPdWQ60y6e9BC0g7yw454jxGxknvPPPLTCmEmvr4+o
         jQyOc5uTm1j/+eRDF0I50hd2Feu4KaSEaRbmpD2o06SjLlkrT1TLNMagfncK5ERtdEbj
         nV6zosE8jrW6+DMO9ozLARiNEIdu8nDbtreoE2Y5WpRZkfGvTM1kYEqcTTW7jUeIST7k
         z7rd+2fGwpJ2RnAmmYf9rZOA/yMB9IqFh0opcUqd99mboBSssoXGZ0xD8KclWqF4HIXF
         YygEy4q7kJm5t9G6gcnUNlKUaX33+UerA/6rA601GCFdTjfWAySi6NG1+tKsJYkrP2nk
         aRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JwcxadUTLm+g1Gzi28tJFADhls3BhprCF3ZKHMeFB8c=;
        b=ycWCx1PerVt6d6//lxUVJB7tytPzB+paEFbcgRFW5YqyTDkIuB2QWOqMZxzFVb2X8p
         rj8qYQ03vyOuxfveon+nN8EfS5UM7uvCcRBtwlEypKeYO8q15HsMjhxfz/CsJJRqi248
         UEGme6+OspXE+4GyzWYPlTJEu+gBrnBUZ5aWTHyMo/qQJZv2vyv8mfXyubUWL7KBe3im
         lpNWncwQIQqmZAuuRFssgb7k65fB1Z7GILyHfKfYIlR80kc20AXaXgxKdKAxqAupAX4k
         YAvNQVoYDT/Fx0YR11+vdMmQxfUIuWISmmHodalGV2EOcLo1TbgmQkJlNgVRAUJ60/MG
         BsDg==
X-Gm-Message-State: AFqh2krk4HIK15N5ygjazqn1n3C2IMfoUvUF/mNR0/NKjAPr1s4CLK+r
        oTLjsJIYLrsyQ2j71eHF46DHQ8AeWydQBkW6cmc4AQ==
X-Google-Smtp-Source: AMrXdXvU5JfvAAWL0e7p6VmuPpU24WUoF5wJWXi8HRTv8y/3bwzSTuA6Bhn8ktIjh+KacUTqih26yptuVyXPtABbTPA=
X-Received: by 2002:a81:72c6:0:b0:4bb:c96d:f685 with SMTP id
 n189-20020a8172c6000000b004bbc96df685mr4321344ywc.208.1673619077771; Fri, 13
 Jan 2023 06:11:17 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673574419.git.william.xuanziyang@huawei.com> <b268ec7f0ff9431f4f43b1b40ab856ebb28cb4e1.1673574419.git.william.xuanziyang@huawei.com>
In-Reply-To: <b268ec7f0ff9431f4f43b1b40ab856ebb28cb4e1.1673574419.git.william.xuanziyang@huawei.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Fri, 13 Jan 2023 09:10:41 -0500
Message-ID: <CA+FuTSfwZNBMnuUXgLOq8Z4s5es13tmK=oPNFWsWG22ztmWQLQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/2] bpf: Add ipip6 and ip6ip decap support
 for bpf_skb_adjust_room()
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 4:25 AM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
>
> Add ipip6 and ip6ip decap support for bpf_skb_adjust_room().
> Main use case is for using cls_bpf on ingress hook to decapsulate
> IPv4 over IPv6 and IPv6 over IPv4 tunnel packets.
>
> Add two new flags BPF_F_ADJ_ROOM_DECAP_L3_IPV{4,6} to indicate the
> new IP header version after decapsulating the outer IP header.
>
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
