Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A3D43C900
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 13:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhJ0L7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 07:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhJ0L7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 07:59:49 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BC3C061570;
        Wed, 27 Oct 2021 04:57:24 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bp15so5642837lfb.4;
        Wed, 27 Oct 2021 04:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=YXg0m4/fJ//WGjGcJyxQ/if/yQiYorndqx8ywLLIUxc=;
        b=jThNapv4PN8aFz+XjA3tDVZi4wprRuBhHugJZuBZP/DlIxvP+7fAyNaCpZfMarEbNr
         32z6q58YY8ApfMWn6WvDE/kcNYwITYRTkN9HyeXEsDEsQTUe74ZXWQHzvkqtfGGj17Qo
         ynN7dn4s3aT1IyjCygoNmPf4h3n+nJe+wc6ms7nrmnKXEULCUyFAj1iT+7tuuCqedvOG
         YOG9Fxav3t2/PAu9/eNGwnbEsLMY0Y+hMxJlEUS/winNQX8Y5womyGufSRlz72jTdk4S
         lRYJkL0mrCi584gmxe06pmVG97mROw8QBmN04nFVOppFqz5rwzzCy/6IidXzwYpfVPtV
         9ibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YXg0m4/fJ//WGjGcJyxQ/if/yQiYorndqx8ywLLIUxc=;
        b=a7M1yZ/bymPVoeu4/tZzMsCnz7PD521oSI0LYp2SYccmdVjuhKATV5OK+/c1pnKtlB
         RZJnot2xP+LDnqbJADvtNYl3rcmSzL4FAbEm+U9fLNFjRUJHP3HZu2nJQo2hxTcVdeUI
         EmIamg//Bajr9XVL6Li/nX4Jqv+zP53L60HtX0o2nNG+jx2vhTSZg4OZBqi4f0uK8rKi
         myazQ8p6T9AIUSf9/MWOU7/BeimezovIwhnAHOVB2LxFZEO6A9q0AD2ppW0nJdNbVra4
         DJkzdvWSoh1s+QNANR7xjFtGqWHWVHj/dFdoOaOIaTlTXjrb2OQ6MFB/4sx+RaVqzZwD
         pIPg==
X-Gm-Message-State: AOAM530JU7H5srF2MevS5DIw+YXvy6RXbi1IufID2WfKlvWBn/9jH0LT
        nc1YaRTehRq5+25k4S+bSd0=
X-Google-Smtp-Source: ABdhPJzG06ZKCx25ZsvM2ShhEKwT6MB3ORkQuYBX2CgoUoilCJl3p64N9h9V/iWAX2ORJiz4HBy9oA==
X-Received: by 2002:a05:6512:1284:: with SMTP id u4mr2381577lfs.226.1635335842638;
        Wed, 27 Oct 2021 04:57:22 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.235.8])
        by smtp.gmail.com with ESMTPSA id p9sm1118651lfu.121.2021.10.27.04.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 04:57:22 -0700 (PDT)
Message-ID: <e4922538-1a57-1d21-9079-e954d742d844@gmail.com>
Date:   Wed, 27 Oct 2021 14:57:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] WARNING in batadv_v_ogm_free
Content-Language: en-US
To:     syzbot <syzbot+b6a62d5cb9fe05a0e3a3@syzkaller.appspotmail.com>,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
References: <00000000000010317a05cee52016@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <00000000000010317a05cee52016@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 02:19, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2f111a6fd5b5 Merge tag 'ceph-for-5.15-rc7' of git://github..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=121d909f300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d95853dad8472c91
> dashboard link: https://syzkaller.appspot.com/bug?extid=b6a62d5cb9fe05a0e3a3
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b6a62d5cb9fe05a0e3a3@syzkaller.appspotmail.com
> 

Looks like bug on error handling path in batadv_mesh_init(). Must be 
fixed by my batman-adv patch.

#syz fix: net: batman-adv: fix error handling




With regards,
Pavel Skripkin
