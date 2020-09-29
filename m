Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B9727BFEA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgI2Iqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgI2Iqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:46:45 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A2DC061755;
        Tue, 29 Sep 2020 01:46:45 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b17so2270589pji.1;
        Tue, 29 Sep 2020 01:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:cc:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=09r7sX9nPa/Tp8/QlC5iZVhoyrOvmOR+znTXY5U9Huk=;
        b=KuZh5q8LhRBsplk2Z5+5mo6NpY1YzTpyJliDMz/+XAGvQNDdpOYW01hURX4sYrwanQ
         cBEZjrNbSPOU3KSHoeb+lpnyN7aW2rMNnx3dzLvXW0v8aft3LETr1V+vsazsJ8AXVnxU
         tSCmjYvRoU1UCCpPqpVys1SrHeJoGMFaqdEj2UfbrNKkuewOQGKgu+hX0Y9FfF8QtXwJ
         bXG7tTqcUuA4vOod125kD4TnPdfBxPRicQi4aDJ0Ejz4H1eOjyszS2P9fxXRYKvuhMPq
         D3t+tXqJ/VHXYcIaJL+wVQNtUL6umnl3crAbkKCt7ycKz2g9W14zqmyYEwEa43AekD3d
         UiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=09r7sX9nPa/Tp8/QlC5iZVhoyrOvmOR+znTXY5U9Huk=;
        b=KBWORzAuuXMFFhOjNCdv7fxZCHpxgz2tOjKp3vJfLsGLCcqNT+7D26ACGlgtDUFNRT
         j6qBcvoqbgpwgmQOEaIg+4upUGdjxKDBZvFFDqnjybCJMc6EkSxSevz/8PG6P8n2QTjW
         ln6K0PYbqovKs73lgOuG1S3ErkCooLexY3quJpsvJ84pdMdUh/HwUoTxvzKY8Ban1piT
         t06ahOupTKEvYOrO41reO+1fkFJRPuq/Z9Ex798QLlV7C6IOw+wbMHa96OYRGoxKfc2D
         3GYgkIQgN3hkidrepkZsACv0nzrmrKETyjvpwNng9FDmsH89N1vurPmcWggIZrcW9BYW
         V7FQ==
X-Gm-Message-State: AOAM530sEO2CWEpr+coh5n0wgiD3sKkqNUve2CGZhg2NhHN6dZCtgLpn
        BsKizuh2C9ktQHeeMPwEn/uB8UHqIhpNrewdrVE=
X-Google-Smtp-Source: ABdhPJzMivhRR0m11JQPMdLJs05kQ+Eu9B5e7Yku9mhzmu6VKvDrS4mAZLNHV9x4GjIZmjiRXP2xZg==
X-Received: by 2002:a17:90a:104f:: with SMTP id y15mr2758898pjd.45.1601369204267;
        Tue, 29 Sep 2020 01:46:44 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.218.220])
        by smtp.gmail.com with ESMTPSA id q4sm4433733pjl.28.2020.09.29.01.46.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 01:46:43 -0700 (PDT)
Subject: Re: [Linux-kernel-mentees][PATCH] net: usb: rtl8150: prevent
 set_ethernet_addr from setting uninit address
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200929082028.50540-1-anant.thazhemadam@gmail.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <d7304f13-1dd8-0760-2c89-6d61c0f6ab7f@gmail.com>
Date:   Tue, 29 Sep 2020 14:16:39 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929082028.50540-1-anant.thazhemadam@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A sample crash report can be found here.
    https://syzkaller.appspot.com/text?tag=CrashReport&x=17486911900000

The line where the bug seems to get triggered is,

if (!batadv_compare_eth(hard_iface->net_dev->dev_addr,
                    net_dev->dev_addr))
Looks like it goes through the list of ethernet interfaces, and
compares it with the address of the new device; which can
end up going uninitialized too.

The address should have been set by set_ethernet_addr:

    static inline void set_ethernet_addr(rtl8150_t * dev)
    {
        u8 node_id[6];

        get_registers(dev, IDR, sizeof(node_id), node_id);
        memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
    }

However, when get_registers() fails (when ret <= 0 or ret > size),
no memory is copied back into node_id, which remains uninitialized.
The address is then set to be this uninitialized node_id value.

Checking for the return value of get_registers() in set_ethernet_addr()
and further checking the value of set_ethernet_addr() where ever it has
been invoked, and handling the condition wherein get_registers() fails
appropriately helps solve this issue.
Thank you for your time.

Thanks,
Anant

