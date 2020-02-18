Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902D01622C7
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 09:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgBRIxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 03:53:22 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:33532 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgBRIxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 03:53:22 -0500
Received: by mail-pl1-f180.google.com with SMTP id ay11so7828027plb.0
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 00:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=LfgzIrLKhdplSUv5x9z4tLvmxYpGNenEmtMwhPZbNTE=;
        b=YgQDfd1XbfeLAkntqPIZdSFrmTw/bsvYqNJ8VHAOJe9N+avtozitaNyDLZqwzJ1LNY
         QRiTrWEbFl7clfPY3wzer5twpfhQjNn20HI9xn2IoOz4mUmeSUSo2Gj8N6UB91MCDWci
         j0WRjsrYb1r4hQH3y+SG3g26j35RItevbHb8ZmvCE/aezjxVYVmpPNT0+SFS6A4dWB+E
         Ed7SEisEUL9yQUgZ2Maa/s0K1oTakugNAqUXiAbKIX0/LrcIb3mkr9lw16MtaqUm1b4K
         Xgd1Hfaa79R+m0oSRzl7Wi5h71JJ9fznX/njGAerT2umak1WFjWaRygcgLS0rS18P8db
         Vajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=LfgzIrLKhdplSUv5x9z4tLvmxYpGNenEmtMwhPZbNTE=;
        b=ZfdwZzX51vN04pabh7EJHlO51fpmzx8CqX+Z5v6wM7VP/oLSSkBLSjDLjjfaimJo/8
         /UAinbh7zVW+xawYhg32UT6/oV9xbqwSO36S/B4F3+dPLT89LCzNo+NsZJJYtvMwdJko
         BOubLykIZD4xvQc70tghm9D81UaKnqDbjIZy6/ubOATuXlBmOVSjhQKxadshieUNWW/B
         bAzSQ4oZj2BdyuoJ57DRhljMSOdFS272Ubrb5ehEnRqMfYiCCuvPdY14iBd7OTpmNKIq
         HfUe/dh+QnzIPzTFGMBlrPclum0ggAhFOHFuPp6I70qapbt//W2a+lWvzROQOhIUdvZN
         I5oA==
X-Gm-Message-State: APjAAAVsCbIXlUh2TVJaf/xuE57mobR8l19Koe1XZ127M0n6tNXHlAld
        9EI10VG/znXakGlj8iMJSXg=
X-Google-Smtp-Source: APXvYqyukS0dlBALI+vm/u6eBsiH7hGYxRva8GO4U2rl7pFg+X55jNAtPpKPTNSoji6Cbg5yiNceyA==
X-Received: by 2002:a17:902:504:: with SMTP id 4mr18173957plf.276.1582016000441;
        Tue, 18 Feb 2020 00:53:20 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 13sm3096709pfi.78.2020.02.18.00.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 00:53:19 -0800 (PST)
Date:   Tue, 18 Feb 2020 16:53:09 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
Message-ID: <20200218085309.GT2159@dhcp-12-139.nay.redhat.com>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <CACna6rzgH0Ltgib+mmDNLMQE5qmU2xBYUFBJDCswvyC1bnonjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACna6rzgH0Ltgib+mmDNLMQE5qmU2xBYUFBJDCswvyC1bnonjg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 09:08:54AM +0100, Rafał Miłecki wrote:
> 
> Thinking about meaning of that commit ("do not remove mld souce list
> info when set link down") made me realize one more thing.
> 
> My app accessing monitor mode brings it up and down repeatedly:
> while (1) {
>   ifconfig X up (ifr_flags |= IFF_UP | IFF_RUNNING)
>   select(...)
>   recv(...)
>   ifconfig X down (ifr_flags &= ~(IFF_UP | IFF_RUNNING))
>   sleep(...)
> }
> 
> So maybe that bug running device out of memory was there since ever?
> Maybe before 1666d49e1d41 ("mld: do not remove mld souce list info
> when set link down") I just didn't notice it as every "ifconfig X
> down" was flushing list. Flushing it every few seconds didn't let list
> grow too big and eat all my memory?

Maybe. before that patch we will remove all the list when link down.
After that we will store the list and restore it back when link up.
> 
> I'm going to test some old kernel now using monitor mode all time,
> without putting its interface down. Is there some of debugging
> mld/ipv6 kernel lists to see if there are indeed growing huge?

I will just try test with link up/down(with forwarding enabled) and see
if I can reproduce.

Thanks
Hangbin
