Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC294CB574
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 04:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiCCDcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 22:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiCCDcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 22:32:19 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA7D205F0;
        Wed,  2 Mar 2022 19:31:34 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v4so3556741pjh.2;
        Wed, 02 Mar 2022 19:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pGBvvXv0+bIemEpOMWx5hDUzr2X3HaovG9ODW4Gck18=;
        b=howYcMrVhW/d8Do6Nlm4w4Jt7BHLOLV+2YwJgPe7YI2G3oBIPY6NNsjLmmzuUE11IW
         s/AWRMmIFli6RvC1P9MjBDurn+s2BLxshmG0WYZdG1sX5zdBg7R8gzkacLFq+PWjbMS7
         deH/AMz5iLaIP69PXbUtgGA4iJtFfyTiCa1O6dwgawKp329pJUx5boFzPPTviUUartB5
         usR9YAwoJ/ZU8CSd5U+oQlFjZIufd/wtVhWz4jdcENMMZBfyKD2OQaJRgaqtiRzb6Alj
         Q+IIrg72P8uUE19PrSWFqvXu18a6k4+/UwEf6Cs8SNddraR4zLPcZcNi+5Sf+2nLNela
         pzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pGBvvXv0+bIemEpOMWx5hDUzr2X3HaovG9ODW4Gck18=;
        b=fUTmliX49S1X6I4sU/Z8S36zgqdD63iQYYfBZIOyezfjmhVphrnwh9779rNK0SafyK
         eOaxqoM/wtVM1I4kzw9cHIlIynB2+nq8ZPBdL+eARmMEshq6WuXTnzTjZPNqZ7Qix4UL
         u4XGWknrvm7xTth6EU5/wiTNyiI0FaTUpTEvjFtLlYxFgOhPzkJfqREtRg1K/jZ6j+h3
         e88/F5wyxfO9n0lK7TtO4CoBZ2N4GZyoNfCyVV2JT46t7QnDgSDCVRiTf1O3mXanQqE3
         OtAmub+c41yW7mmnLVWFv8SG0Dq4/tKVk6OugJfSLF1iz4MFrzropk0/r19OmLecvb5I
         bo2A==
X-Gm-Message-State: AOAM532P7IJbSwSS4tpGeakkzmsaJE5FZnaZBTJF58NYnA9sx23PbNOk
        C7XmGzClcATXs77nfKghNv8=
X-Google-Smtp-Source: ABdhPJwVQjxrQ0+UJfpvvM58vmsnYjycON6psaMhdHTnaETmUhm7UVpWWj7w8EURRXPSwTwHGXSXjg==
X-Received: by 2002:a17:90a:7147:b0:1bd:24ac:13bd with SMTP id g7-20020a17090a714700b001bd24ac13bdmr3147872pjs.70.1646278294550;
        Wed, 02 Mar 2022 19:31:34 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.19])
        by smtp.googlemail.com with ESMTPSA id ot13-20020a17090b3b4d00b001bf0b8a1ee7sm566981pjb.11.2022.03.02.19.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 19:31:33 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     james.bottomley@hansenpartnership.com
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org, jakobkoschel@gmail.com,
        jannh@google.com, keescook@chromium.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable outside the loop
Date:   Thu,  3 Mar 2022 11:31:22 +0800
Message-Id: <20220303033122.10028-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <c0fc6e9c096778dce5c1e63c29af5ebdce83aca6.camel@HansenPartnership.com>
References: <c0fc6e9c096778dce5c1e63c29af5ebdce83aca6.camel@HansenPartnership.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Mar 2022 08:02:23 -0500, James Bottomley
<James.Bottomley@HansenPartnership.com> wrote:
> pos shouldn't be an input to the macro since it's being declared inside
> it.  All that will do will set up confusion about the shadowing of pos.
> The macro should still work as
>
> #define list_for_each_entry_inside(type, head, member) \
>   ...
>
> For safety, you could
>
> #define POS __UNIQUE_ID(pos)
>
> and use POS as the loop variable .. you'll have to go through an
> intermediate macro to get it to be stable.  There are examples in
> linux/rcupdate.h

The outer "pos" variable is no longer needed and thus the declare
statement before the loop is removed, see the demostration in PATCH
3~6. Now, there is only one inner "pos" variable left. Thus, there
should be no such *shadow* problem.

Please remind me if i missed something, thanks.

--
Xiaomeng Tong
