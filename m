Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4CB8E0DED
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 23:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbfJVVxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 17:53:31 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36266 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfJVVxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 17:53:30 -0400
Received: by mail-lj1-f194.google.com with SMTP id v24so18827398ljj.3
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 14:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=W2npVtcG6PPK1sBk+av9eVVt2fGsxaCw501pj1Dc9+A=;
        b=NMTToeJXypLeo7tPb+hTSXjhB4E0wIQpVUpmHAd1spoQl7Lp8D0lcaTZC7CVFPTEzz
         dQe3xKWB4xeCD8h21VGsdA+V3BlTTZoE56dOdog59zIXct17x39RV2M1DCSUJ7OaVjjG
         3NMyhxAJ6GN7CuExctPJaui6ZTpe2aebznuM0v++fwvjNoDDF57zKGWrsdb5ZwIbEqwj
         6xo2kIA/oTD+Ixwe7PXOkq1sXG9wJIAdDDCpxFh5gcTT22FAPX3r6PRUfrd+LWcsnmvQ
         Ql35MT74OXa215ZmwRZFb7Rn82ccg9enMgsMWPB+Ka6zHiZH516xGhelMbCeftLIBCw2
         ZgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=W2npVtcG6PPK1sBk+av9eVVt2fGsxaCw501pj1Dc9+A=;
        b=FgQuNaH6uIfZqZbBV8R+7bna4kWpV5S4o0RbptbKZBkqs5xi+9TR2F01VoL/9kRQD5
         c15BeiWuvMtT5PgQT0WBNpuUc8LEXoxmVOZhsNtil9CKsOOSk4Gyz3dltQbh0QdiOZHh
         sjSR2Eo4T+SyrIt+DwSi/kWhH9Ar6M1Hz5KER8gI/W3SOxzS930fNJfVjCeakIDf1ykU
         YE7x7DSAjEUTv/q9L3L1Dq6qvRWeVhJMyfUskQvnBY6i+1iZk52HUYGowHyT4i8mI+Wg
         lYGRHXy61S1eXhTSg3MqeOHtiHr3jc+lzGNHUrU73Ru6EevyistdpsOqNyDoVgHn8zwE
         j5Xw==
X-Gm-Message-State: APjAAAWENl6IMNSXHrzs3GOxl6GeLRJ/RKCUl83gT6PKS8ne0ZLZDEr+
        iamqccsHmbGAUeAexpOIdLHiWw==
X-Google-Smtp-Source: APXvYqyG6lJ1MTU1BIHSQWgMhFHJOz4Ofu255vkELhXLhlasXNwp6wjZ/ngdPYkUeYcy3V42rCmGXg==
X-Received: by 2002:a2e:b816:: with SMTP id u22mr15818109ljo.65.1571781207083;
        Tue, 22 Oct 2019 14:53:27 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j26sm7635866lja.25.2019.10.22.14.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 14:53:26 -0700 (PDT)
Date:   Tue, 22 Oct 2019 14:53:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Hillf Danton <hdanton@sina.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ying Xue <ying.xue@windriver.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: Re: [PATCH net] net: openvswitch: free vport unless
 register_netdevice() succeeds
Message-ID: <20191022145316.63bf3b5a@cakuba.netronome.com>
In-Reply-To: <3caa233b136b5104c817a52a5fdc02691e530528.1571651489.git.sbrivio@redhat.com>
References: <3caa233b136b5104c817a52a5fdc02691e530528.1571651489.git.sbrivio@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 12:01:57 +0200, Stefano Brivio wrote:
> From: Hillf Danton <hdanton@sina.com>
> 
> syzbot found the following crash on:
 
> The function in net core, register_netdevice(), may fail with vport's
> destruction callback either invoked or not. After commit 309b66970ee2,

I've added the correct commit quote here, please heed checkpatch'es
warnings.

> the duty to destroy vport is offloaded from the driver OTOH, which ends
> up in the memory leak reported.
> 
> It is fixed by releasing vport unless device is registered successfully.
> To do that, the callback assignment is defered until device is registered.
> 
> Reported-by: syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com
> Fixes: 309b66970ee2 ("net: openvswitch: do not free vport if register_netdevice() is failed.")
> Cc: Taehee Yoo <ap420073@gmail.com>
> Cc: Greg Rose <gvrose8192@gmail.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Hillf Danton <hdanton@sina.com>
> Acked-by: Pravin B Shelar <pshelar@ovn.org>
> [sbrivio: this was sent to dev@openvswitch.org and never made its way
>  to netdev -- resending original patch]
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> This patch was sent to dev@openvswitch.org and appeared on netdev
> only as Pravin replied to it, giving his Acked-by. I contacted the
> original author one month ago requesting to resend this to netdev,
> but didn't get an answer, so I'm now resending the original patch.

Applied and queued for 4.14+, thanks!
