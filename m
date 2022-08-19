Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2C559918E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240629AbiHSACW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbiHSACV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:02:21 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956BABD16A
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:02:20 -0700 (PDT)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id CD7C33F146
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 00:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660867338;
        bh=7k6Ey5eV3p7VgCTHQJLzyvChQ1kVh0YdJm5lPwWfibI=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=vMICorseVjb0LJEzkezIw8/tYA8PRjWl0rTdB4iVWT3pihMHYIjY8K1f6XIScI6UW
         tdPmAGokAotiUZTpQ8RAG9IjbQEBDQbklaBgKCWZZwM1k85Gr172rQx2iXmEQ0bJtq
         qh6fV9Ztto0K9weQkI+/RnQfvK8fNKm56j1EUTyB5u7+8r7UAF5vd5Qm0coY89PrIo
         ftJQJU+7lGs2osbe4Rh7KiYP9nO+kURlK7PNt2xYhj2S4N486OJwVKiZRM5LSS04fF
         Wb4ODkp5I56WLLKMoD/oUUO/sz11MzTDQZ9lcpgA8yBUnNZr4glJ4ePgfGPXoLPPuh
         JvGGoi+svznSQ==
Received: by mail-pj1-f72.google.com with SMTP id b5-20020a17090a12c500b001faa33a11dbso1725871pjg.1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-id:mime-version:comments:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=7k6Ey5eV3p7VgCTHQJLzyvChQ1kVh0YdJm5lPwWfibI=;
        b=koKNICYy7+PeFOE2EGhEI5OWCJv4kb2I5VEn9aS0eVqPMKK7G3DO7CsPrZWru52eT2
         Rfxo5HuLw4Yk00idTCFtkfFwAOnd3ov+d1S9/zPaW+yy3p5m1uNwovrAQG+5jA0XZKxR
         XwiZTZXtFPa2WUFSxQiscMQeQ6VW7GyqFD5TjZrTscOUVnRjDvowgfeEnVBQP8HxSond
         C9aUaQfYxerbcg1cCGgxoc5tQd/qOkt2OQ/ayxrA4KtSWDO+pqnjr6Y9FvPrm39nY6aO
         dbGkhB+UaartxnhZKu7b/9TOW7YvFvRO7wkV+5tJmXP/oh22blqZcHSBsogGDKV7y9bK
         bBKQ==
X-Gm-Message-State: ACgBeo2WVwofNasdDaoMBX5kjIxCnOuyrauRMIaNN8kxzCV/qSqv6U1T
        v0DgZGxSBXsWcTAmSRD2T8kk/qEaqFtNgctOcbHNTbmI+ndofPpp9eHjLHknuzQG1qLQsz+JIwz
        m7hD0+0oxcKa97RE1QC7tOcfIchwd4FtXpQ==
X-Received: by 2002:a17:902:8e8c:b0:171:2a36:e390 with SMTP id bg12-20020a1709028e8c00b001712a36e390mr4930707plb.77.1660867337280;
        Thu, 18 Aug 2022 17:02:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7tsADGEvtfq2lzlYsXUzlIvnxUPWj2ZEjtXGmfARMOFLh1b8QjneTBFlyZYVM6KsvCbnB20g==
X-Received: by 2002:a17:902:8e8c:b0:171:2a36:e390 with SMTP id bg12-20020a1709028e8c00b001712a36e390mr4930682plb.77.1660867336952;
        Thu, 18 Aug 2022 17:02:16 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902e74500b0016db774e702sm1947613plf.93.2022.08.18.17.02.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Aug 2022 17:02:16 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 07C8761193; Thu, 18 Aug 2022 17:02:15 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 005CC9FA79;
        Thu, 18 Aug 2022 17:02:15 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     netdev@vger.kernel.org, liuhangbin@gmail.com
Subject: Re: [PATCH net v4 0/3] bonding: 802.3ad: fix no transmission of LACPDUs
In-reply-to: <cover.1660832962.git.jtoppins@redhat.com>
References: <cover.1660832962.git.jtoppins@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Thu, 18 Aug 2022 10:41:09 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17839.1660867335.1@famine>
Date:   Thu, 18 Aug 2022 17:02:15 -0700
Message-ID: <17840.1660867335@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>Configuring a bond in a specific order can leave the bond in a state
>where it never transmits LACPDUs.
>
>The first patch adds some kselftest infrastructure and the reproducer
>that demonstrates the problem. The second patch fixes the issue. The
>new third patch makes ad_ticks_per_sec a static const and removes the
>passing of this variable via the stack.
>
>v4:
> * rebased to latest net/master
> * removed if check around bond_3ad_initialize function contents
> * created a new patch that makes ad_ticks_per_sec a static const
>v3:
> * rebased to latest net/master
> * addressed comment from Hangbin
>
>Jonathan Toppins (3):
>  selftests: include bonding tests into the kselftest infra
>  bonding: 802.3ad: fix no transmission of LACPDUs
>  bonding: 3ad: make ad_ticks_per_sec a const

	For the series:

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
