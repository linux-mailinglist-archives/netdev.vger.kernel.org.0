Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473F74C8AE2
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 12:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiCALf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 06:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbiCALf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 06:35:27 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E928691AD3;
        Tue,  1 Mar 2022 03:34:46 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id bd1so13181044plb.13;
        Tue, 01 Mar 2022 03:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aWgEFJTpYXNiaEJiWv3F+tbzx+IqWWKw7jaIBciD8Os=;
        b=aZenmRcKS+72f0iaWCAWfTCKuiegNfIDv/B5+b8zu6mriIGbqlEHrnVmRXLkUAdP4l
         6T5E3AdPtPWAJNoOBlkx3DvA4q5DYk0QSwO7+CfXjMZjvniJwdCzPgTHyv8b4EgdvsS5
         dBnR+gohco3QQCLx+TycKAvezaGxweKGMdggmunuSpk/sIILKbMPTwLL2+h9AFvQ9q3V
         35D+o1DI14QvOktkzQLGmkYY+pBNLYBlxjKKNna2/K4JuF9BHKndbYva24v0ZpKUUGD2
         s3rzi8WF8ONdK7QR5htLoJoWzhuYNrM4+85rnirf3eNnlodVZJJLp1Oxp1ABVEG/LV+/
         xfmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aWgEFJTpYXNiaEJiWv3F+tbzx+IqWWKw7jaIBciD8Os=;
        b=P0OJ844zLj+PofqX+Vk7/aSR5l/cCXv4mP5aabOVjW0qoovbSUiDZD0Z3v8FAnA2vi
         Gyq9XYROuogBh2HTmFWrJqpoiZ81ko2eah9Y6hMVCDisHKvLb+aoZRIs7eq1shu9pnhQ
         dsEXY9b88qdnfMikOoolCO65ZkerZOY+hR9wTU8UBARh4dLpQOT83b8jsmBYG1xNCxJi
         5H1GuOdz53lLEZoLWpWfg1SwTcny2D9vEGeVN9WOxYYGaiIEqZhuhyLpTuL1NQIYbm8f
         /zs1fhI23JDffDs+cHs7vx4Fqlh20oYuDnCLkYrrA3FvHqnawME6v3ta9ED1igBPoVfP
         l9NQ==
X-Gm-Message-State: AOAM531urTIKz5EAvjp/XYHAlj6KTH+AAsrmd26RAAHc1OoiUgpa+XY6
        I4NbPo63gizz4MXHmx8Z83I0LGPFp+fnzA==
X-Google-Smtp-Source: ABdhPJwXbt6uatXc9SN0Qdbkjvc/d0cGc37tlZ9ZEuA4/UQXUJQLcM5LqrZabJXlP3EDSH/mJMubYg==
X-Received: by 2002:a17:903:120e:b0:151:71e4:dadf with SMTP id l14-20020a170903120e00b0015171e4dadfmr6536841plh.48.1646134486464;
        Tue, 01 Mar 2022 03:34:46 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id d4-20020a17090a8d8400b001bc386dc44bsm1963828pjo.23.2022.03.01.03.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:34:45 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     arnd@arndb.de, jakobkoschel@gmail.com, jannh@google.com,
        keescook@chromium.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, torvalds@linux-foundation.org,
        xiam0nd.tong@gmail.com
Subject: Re: [PATCH 3/6] kernel: remove iterator use outside the loop
Date:   Tue,  1 Mar 2022 19:34:36 +0800
Message-Id: <20220301113436.5513-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <Yh34XhiUg6T/14kF@kroah.com>
References: <Yh34XhiUg6T/14kF@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Mar 2022 11:41:34 +0100, greg k-h wrote:
> On Tue, Mar 01, 2022 at 03:58:36PM +0800, Xiaomeng Tong wrote:
> > Demonstrations for:
> >  - list_for_each_entry_inside
> >  - list_for_each_entry_continue_inside
> >  - list_for_each_entry_safe_continue_inside
>
> This changelog does not make much sense at all.  Why are you making
> these changes and how are we to review them?  Same for the others in
> this series.
> 
> confused,

I'm sorry for have created the confusion. I made this patch to remove
the use of iterator (in this patch is "ext", "cur", "aux", "q") outside
the list_for_each_entry* loop, using the new *_inside macros instead
which are introduced in PATCH v2, and to prove the effectiveness of
the new macros.

The detail for create_mem_extents patch:

1. remove the iterator use outside the loop:
-		struct mem_extent *ext, *cur, *aux;

2. declare a ptr outside the loop and set NULL:
+		struct mem_extent *me = NULL;

3. repace list_for_each_entry with list_for_each_entry_inside, and pass
   a new argument (struct mem_extent) as the struct type.
+		list_for_each_entry_inside(ext, struct mem_extent, list, hook)

4. when we hit the break in list_for_each_entry, record the found iterator
   for lately use:
+			if (zone_start <= ext->end) {
+				me = ext;
 				break;
+			}

5. when we miss the break, the "me" is NULL and can be used to determine if
   we already found the "ext". And replace every "ext" use after the loop
   with "me".
-		if (&ext->hook == list || zone_end < ext->start) {
+		if (!me || zone_end < me->start) {


6. repace list_for_each_entry_safe_continue with
   list_for_each_entry_safe_continue_inside, and pass a new argument (me)
   as the iterator to start/continue with.
-		list_for_each_entry_safe_continue(cur, aux, list, hook) {
+		list_for_each_entry_safe_continue_inside(cur, aux, me, list, hook) {

Best regards,
--
Xiaomeng Tong
