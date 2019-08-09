Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AED86EBC
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 02:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404787AbfHIATq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 20:19:46 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34830 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404558AbfHIATp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 20:19:45 -0400
Received: by mail-qk1-f193.google.com with SMTP id r21so70448419qke.2
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 17:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hJMvu/bbGMstrnewPFAYRHW5WokfxwcPC/wDK1WVJ88=;
        b=z4XNvgin7nFh4kPDTEhzofo8m0g4DMGAn/yrIhKc8IjS025H7JUWO8DNbfeH/nOshY
         JD/N0uUYliB5FmyoXXiC1udK5khqLISJ0NMcRhMXbO2DRFwdB8J5OicKZHBjC5Xu2VUJ
         wTEkK46qcvahJtbTvst3BO/dNssrK1cGsea5uj+z5/zECRnJ2KkpAZv7TO0aspenNPIv
         BzFuUZLcgiAQ9V2aHBiAMqKOBhRNT3MC5w1CVjbX86nf0URIkcjyFsm2Y44FttDJQbuT
         pK0NlxwF/0FpE+HDWNhjUJGlbKE8NQt6U0jyN2jSDYtOPjJlKITwIslVfAZXL/b4ImXl
         TVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hJMvu/bbGMstrnewPFAYRHW5WokfxwcPC/wDK1WVJ88=;
        b=OVRR8moFflLpnPX5z8nzj+vNAf1I2zxdasZXKtPyfQrq/78gV+J1ji2bJN5QzOpF3J
         pYHxTt3nTsbiJ8Cy3L74SI7zRYiy8P3f9Hue4+EEjnL+jpWsdJjTcr3+gD6nisKYE/Ot
         O3LBcxWElHYViLU9rT8behEhFB7+Bsm5WoYQWp9VssKDPGd6QrlD0ybBfDSonwrphvtb
         15wNhrzxocRzIZ+YKVHPVkjsA/sHsoXUMRJjLlfH1+N/UVBIn04eqlKWKgPnqp+Ijw4O
         d1+AZ7G8u7Iv7XuTH3hKQ19of6vTiWoxP5mbfBuv601yfLZ8PRQVeGJwGFmlQDcmVk20
         wo3Q==
X-Gm-Message-State: APjAAAXiFwhBwNwnQKJBu660j9xDbtmvOTUxWG5rUzvMoLAZUFXlFu9U
        5Q8uUnM1F6ATNYIkcyuirCDaRA==
X-Google-Smtp-Source: APXvYqxbmXOq4kKnGHFk685MiQxRvF1/WB+ij0S0Lr+A3JFDTPnEB+HHNnX5RvoExNme8uKrtDtrvw==
X-Received: by 2002:a37:9ec6:: with SMTP id h189mr4525284qke.280.1565309984935;
        Thu, 08 Aug 2019 17:19:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f12sm289605qkm.18.2019.08.08.17.19.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 17:19:44 -0700 (PDT)
Date:   Thu, 8 Aug 2019 17:19:40 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+97d0cf528b9c8e9be7f4@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: general protection fault in tls_tx_records
Message-ID: <20190808171940.1e7fcbe3@cakuba.netronome.com>
In-Reply-To: <000000000000216779058f9dc40e@google.com>
References: <000000000000216779058f9dc40e@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 08 Aug 2019 09:44:06 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    ce96e791 Add linux-next specific files for 20190731
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13ce4fd0600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fca5b9d53db6585c
> dashboard link: https://syzkaller.appspot.com/bug?extid=97d0cf528b9c8e9be7f4
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Looks like this was an old tree here, so most likely:

#syz fix: net/tls: partially revert fix transition through disconnect with close
