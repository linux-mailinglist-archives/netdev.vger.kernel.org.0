Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BE46699D7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241932AbjAMOPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241732AbjAMOOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:14:02 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D82D1ADB8
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:13:12 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-4d4303c9de6so135251817b3.2
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=76yLym9Pl5i5ZYoGuk3TgA6N8QwIkLpItLvMIbVU+Qw=;
        b=Bd2oGgvmtvv8m3hvuYRyTPL+ce3647OKK6ub3PnG4oiOuaPdYXKRFbtQe7Y29wMjlq
         upcNBDlgD7f/VOaDtb+dOXAvGM4PZD+f2HxXcjvIaj8jDDlxA+4O1kFUeB3stEdLZlX4
         de2HfuoSCxWGhyWQRravhXgsdOaYWGBMwm78TZlMUMQxe+yq5tQH9i8NUjyURdUTeqgW
         FZADNNYdnXufibf4K80tmQlJskwGt6RjC0IAbMvYxZfTRNLlqMzVQ9iMYZvUnrGe7Y//
         funDTCKjVbREiBljq1OtetuqvDxWP0aHmev2TmTnxvsb8EbjPkPTuS/TEX8WXoLtdAf8
         KTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=76yLym9Pl5i5ZYoGuk3TgA6N8QwIkLpItLvMIbVU+Qw=;
        b=HoxCTMR4QSp4WeMDK+acrdfZz0hfBXyooHNwWFcK3Zc8g6WMPCRegCP78dDw4fs8Vi
         Xk6fpqvbxdDb3URVsImN7A6BsE2d7m/a2yW0QUkTaBDeVaWNdHHEfnYWfp9LFN8upjWb
         0FXp8TB3rZyljxfqOqUVpT8KSqfPNHOK43jrzdUswd91tVgFyzIiVuT3T538nH5NwEaO
         ov/nmT0Rb+9ScZBav8SG6xrCb7vsRJ+KE2h4jbrjSDMMFknwnjRYawSUjBK9Z7pgCm8o
         Yf5RaeG72TNtF+bINA6QinxIpLhfG4lRdN+fsMObEbFPL1uDgFC+RN520erVpE5EdndG
         8iow==
X-Gm-Message-State: AFqh2krJ6VH+b7cqMf/BFXljFQPMchikray08UBQIEHTXlIXHPNQlgfh
        6C7BfDpd5tb+q7ZPuXcjCAYUz0QAUY3quExTReOwJA==
X-Google-Smtp-Source: AMrXdXuNQmry0hopnvbmjTdDmMUEaKqzdqBPNc6ktLZWN1O0Mw223eC5M9150oRRIscMgWEXxHz+l7j2CVfNFUXBqhk=
X-Received: by 2002:a0d:dfca:0:b0:4dd:c62f:d65a with SMTP id
 i193-20020a0ddfca000000b004ddc62fd65amr229576ywe.427.1673619191342; Fri, 13
 Jan 2023 06:13:11 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673574419.git.william.xuanziyang@huawei.com> <dfd2d8cfdf9111bd129170d4345296f53bee6a67.1673574419.git.william.xuanziyang@huawei.com>
In-Reply-To: <dfd2d8cfdf9111bd129170d4345296f53bee6a67.1673574419.git.william.xuanziyang@huawei.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Fri, 13 Jan 2023 09:12:34 -0500
Message-ID: <CA+FuTSdJ+FiuSOaZ_i9STX_RmJAZRwg4MjZkcXPVu_YD0GsZ5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/2] selftests/bpf: add ipip6 and ip6ip decap
 to test_tc_tunnel
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
> Add ipip6 and ip6ip decap testcases. Verify that bpf_skb_adjust_room()
> correctly decapsulate ipip6 and ip6ip tunnel packets.
>
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
