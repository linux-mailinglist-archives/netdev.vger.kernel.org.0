Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9B14E988E
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 15:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243412AbiC1Nqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 09:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243414AbiC1Nqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 09:46:53 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC784D60F;
        Mon, 28 Mar 2022 06:45:13 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2e5757b57caso149299367b3.4;
        Mon, 28 Mar 2022 06:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZQ0ps78hrvGNK6vW07h87pX9FYH0JqPOOOrmPTS+h6s=;
        b=n7dXTXdlJ+o57awDU0dpp4GYsx6wl6OKpYN0Ef/xulA6vvMuNjPDNk7zI6REb+liRS
         VMs7ZnGSmGJml8tVDSYPKv69v8Eq2vCOFoC3WC+SXupgUCVkl+peBobzawO5RbzD5ZgB
         WJXVEioVaIUExS4mik8xoPYl4pTMG1DiqW6LxPgVg/1/Q9WKZpO/7KpjYAo3TDCYa5vJ
         nrGBttfmqvF5KqXZms2ygIeKRUaAwNMy1ZD4z4OpNftWdqseDyjdzFNkHiCN56HJafxO
         hv1fwtIqV808rLabKmsL93YsAEFhu54nWlFtRFO1RkTdVthS1nOxZWgr6tRcdLGt+sos
         MQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZQ0ps78hrvGNK6vW07h87pX9FYH0JqPOOOrmPTS+h6s=;
        b=XwspngGsnI8rfAfHa45s8qBe5j0CuOD1FD8S03Y5x+nzNXDx+R8Yw54Xt8U3TNQcX1
         PQsMTWhvsjs+3kqFdk0lR8w2AAoWgok19llpZzPyr3seryxy5qpWIHAVFR0tfabUKE2r
         bgGt6RrPg/gwuLQ+6T1IkDSNu5gdukI//d5DnLaVwQPm+5JHs/HVoK16Bg4NUdWazrEP
         8lBSG+XlYeL/Zyjeo/Zt6D71Du1To9MnEvizBiahXNcNdhyytSpot/8JecuwFGola0XC
         nk/IG8mHGO+cS2SXG3wxeW7/17v8v7uHndZfczrSX0bXGRopxcntaedkwmBi5zdHmt5/
         qWUQ==
X-Gm-Message-State: AOAM533X5DVieVOFUcOAIeNtCo+wCNTU0EjLR4Lc0VRIVa17YMe8vQQz
        gDKXodcdiIx2cTC2J6r7G1lOoajDBHr6BHUpGOE=
X-Google-Smtp-Source: ABdhPJwIDhdCd3IkS0D2We7a/KiRyZKZsY9kiztJA7dGbxLGYT/79l2IKXVSFRX0m64D4N8AMrNbBk4+My3ookZUKXM=
X-Received: by 2002:a0d:ead6:0:b0:2e5:952e:af45 with SMTP id
 t205-20020a0dead6000000b002e5952eaf45mr25994290ywe.22.1648475112322; Mon, 28
 Mar 2022 06:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220322162822.566705-1-butterflyhuangxx@gmail.com> <2579412.1648468635@warthog.procyon.org.uk>
In-Reply-To: <2579412.1648468635@warthog.procyon.org.uk>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Mon, 28 Mar 2022 21:44:51 +0800
Message-ID: <CAFcO6XNf+nXzWc9XyqBO01uTYkJsoEgi3ZMXt8MhKvSu39vbPQ@mail.gmail.com>
Subject: Re: [PATCH] rxrpc: fix some null-ptr-deref bugs in server_key.c
To:     David Howells <dhowells@redhat.com>
Cc:     marc.dionne@auristor.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        linux-afs@lists.infradead.org, Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

No other syzbot report references it.


Regards,
 butt3rflyh4ck.

On Mon, Mar 28, 2022 at 7:57 PM David Howells <dhowells@redhat.com> wrote:
>
> Xiaolong Huang <butterflyhuangxx@gmail.com> wrote:
>
> > user@syzkaller:~$ ./rxrpc_preparse_s
>
> Is there a syzbot report to reference for this?
>
> David
>


-- 
Active Defense Lab of Venustech
