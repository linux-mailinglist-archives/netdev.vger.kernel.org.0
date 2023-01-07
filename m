Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58F4660EB5
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 13:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjAGMZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 07:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjAGMZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 07:25:50 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0489B;
        Sat,  7 Jan 2023 04:25:49 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id ay40so2784548wmb.2;
        Sat, 07 Jan 2023 04:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4COzEezxUwScBdBUCQmXBfkEZMLwyu6bk+7AMynRWyg=;
        b=I5VR5+vkAsCwsaI6ASMeQWrTa120CyUxdOBt5Y9vBflQ04CpFbUXl/oT0b0dwXCY89
         kJi0N1tFqkEzvTZZHaJt9I8RKT8splcT/Zl+lL0fKC/eZO89ND0RfB0FU/lCzYUhj+60
         fDvkXsinZrgSvUeZXCEUDeFOrQpES84p7A+qQNd2bdPQzG6dAK8oZ7w0w/pWMik2LjnZ
         bEHwTw3gu37tVxD8H/8geT2VanX+56vAOao3rGJidMAZaaH01FZSARVT2kerssmrYvsU
         zbgM7sxddq6O9884XayiWnbtM5y15B1WGXNX8h5Ey3dY3gWTDuuIdvPNK6JbH2SaiIKU
         Ww8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4COzEezxUwScBdBUCQmXBfkEZMLwyu6bk+7AMynRWyg=;
        b=bsBBrXqGtF2p5FiJCV62ytukP4Gft+4lvSaMi/IxIN31ZcnE4IQG3EZINSZkk3UXO8
         Nbnp3dgtSPaQZnxAfCAlTk9f4QSzTbqWpSNne3twQcKUkOzakDz3aMo753IdfXxqslS0
         9vsOJ17puLEm22Ltf1WSnobAf+xofg9t2JRSE1lzTYkehkrdvSjKEMIDt+Q3jOAjmKzB
         SQ7NlVnhRCQJr85fjNUKiIuENFRVLRQACwR+Z/m0oebcaxtvuwk8511rRYzBWggnD4F3
         PohwIzmweOFCewdtHFfsshz87xZlUCMGR5OXpJuz7jL3Gq30PcdcglKDIKp2K2eXx8ds
         23nQ==
X-Gm-Message-State: AFqh2kpZWlTX1P2yOmJb+skOUdSeLUAYKcfjwze6/qxzoFD9PERKzPya
        3Uek9nfmxSgPK184TOdOH8j/Rfab2yYq3Q5DIak=
X-Google-Smtp-Source: AMrXdXuoxk+kSH4s4jQ1Y0U/fOWreciZvBdhze/y2hpfixFDrnEwat9Yno2iIxYY6rxJOYP7almCdI7xoruT/azd9Gw=
X-Received: by 2002:a05:600c:4153:b0:3c6:c182:b125 with SMTP id
 h19-20020a05600c415300b003c6c182b125mr3835738wmm.145.1673094347954; Sat, 07
 Jan 2023 04:25:47 -0800 (PST)
MIME-Version: 1.0
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com> <20230106220020.1820147-2-anirudh.venkataramanan@intel.com>
In-Reply-To: <20230106220020.1820147-2-anirudh.venkataramanan@intel.com>
From:   Anatoly Pugachev <matorola@gmail.com>
Date:   Sat, 7 Jan 2023 15:25:36 +0300
Message-ID: <CADxRZqw2K1QT2cEa6U_4DUxgYrwMiZzU4Qy6iXVm2WRTYVa=xw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/7] ethernet: Remove the Sun Cassini driver
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 7, 2023 at 1:00 AM Anirudh Venkataramanan
<anirudh.venkataramanan@intel.com> wrote:
>
> In a recent patch series that touched this driver [1], it was suggested
> that this driver should be removed completely. git logs suggest that
> there hasn't been any significant feature addition, improvement or fixes to
> user-visible bugs in a while. A web search didn't indicate any recent
> discussions or any evidence that there are users out there who care about
> this driver. Thus, remove this driver.
>
> Notes:
>
> checkpatch complains "WARNING: added, moved or deleted file(s), does
> MAINTAINERS need updating?". The files being removed don't have their
> own entries in the MAINTAINERS file, so there's nothing to remove.
>
> checkpatch also complains about the long lore link below.
>
> [1] https://lore.kernel.org/netdev/99629223-ac1b-0f82-50b8-ea307b3b0197@intel.com/T/#t
>
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Do we drop/delete a working functionality by only taking in account
git activity ?

What is a proper way to decline patch series (vs Acked-by) ?

Thanks.
