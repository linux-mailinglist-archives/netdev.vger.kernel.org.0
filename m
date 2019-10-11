Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821D2D3C14
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 11:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfJKJQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 05:16:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38757 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbfJKJQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 05:16:56 -0400
Received: by mail-wm1-f68.google.com with SMTP id 3so9461253wmi.3
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 02:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YIAO0bdZaQFb74O/6xtQbACiIf7IB3jqcbsiEt3Cf8I=;
        b=DwJ0PqYL0C5d5E4BAAPjFxM5w7QqDbFaVB3IBgocI76BWEcDB6rlaz3TZWztUpwRVA
         t191aTFNWMIW17eUDW7MUuBInq7Q/WgZc2gvF4i8vk+/aSG9W27vm2BqbMAWDrsAwznt
         GRaYBzVlp1hRFlcdAVf+4zOcu7z2l8Zh2jowvljzZdwFOaKiJzqhXfBwfOUoySfy+2Ur
         n9PCZt1Q1FvN7pbGGGJ+ap8qhMPs666Cc/c/RnKdzIs+jPHGse86vB8we4YNhS1aMrXw
         M9bex96lvJdSGDNVUmhh/tlUWJKtBHqT8eQHyPP36pzrmOo+5fs3yKeN7gj3pG6ApuE4
         U1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YIAO0bdZaQFb74O/6xtQbACiIf7IB3jqcbsiEt3Cf8I=;
        b=pcFPidSCAFQ/ZrdjGk2uSaiumpjkEB8AmR/nuSKemCrFRy8kURtjmuzaVJ0PzqMI8y
         OW6bgB9JPU2OpL3plXN8SYdJlpvcrWMNY/pbTYB1GOxFlCxHU8p7AGTiHDUN6VAx+sHR
         XCwi+PrL0bsX8yKiuHnivRjsN7noNYSdiDMp6lVCqi4Ktu/ySPeY3daKzysYgyMqMrxx
         a00L98QAtRfQ6c39+8oUOqXEXpm34a0nEuelZpAhuyrxixaIyhLLxrwqA4fjkqMyaPfO
         56qauo3EtNi/GQlmCtkvaviWT9GMJ916zGrNobkDCS/Iu5fn/0Zv5d3g028tWaRz0Uw9
         eRXw==
X-Gm-Message-State: APjAAAVojJzTh3ke2P+/cUriRb3MU9S34IfDmwaZ5QQOVCDxRGLZoyoL
        /lkOAfxpqacnW9nxEnMX3pPbjw==
X-Google-Smtp-Source: APXvYqzDedr9xgqiM5TMIJH5fp4aE3lgiLkYnrKH7amHl6sEZUWjsEKx3YbzgtO0k1ANP4F0NbWhEw==
X-Received: by 2002:a7b:caea:: with SMTP id t10mr2302487wml.118.1570785413878;
        Fri, 11 Oct 2019 02:16:53 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f13sm8233327wmj.17.2019.10.11.02.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 02:16:53 -0700 (PDT)
Date:   Fri, 11 Oct 2019 11:16:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] genetlink: do not parse attributes for
 families with zero maxattr
Message-ID: <20191011091652.GH2901@nanopsycho>
References: <20191011084544.91E73E378C@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011084544.91E73E378C@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 11, 2019 at 09:40:09AM CEST, mkubecek@suse.cz wrote:
>Commit c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing
>to a separate function") moved attribute buffer allocation and attribute
>parsing from genl_family_rcv_msg_doit() into a separate function
>genl_family_rcv_msg_attrs_parse() which, unlike the previous code, calls
>__nlmsg_parse() even if family->maxattr is 0 (i.e. the family does its own
>parsing). The parser error is ignored and does not propagate out of
>genl_family_rcv_msg_attrs_parse() but an error message ("Unknown attribute
>type") is set in extack and if further processing generates no error or
>warning, it stays there and is interpreted as a warning by userspace.
>
>Dumpit requests are not affected as genl_family_rcv_msg_dumpit() bypasses
>the call of genl_family_rcv_msg_attrs_parse() if family->maxattr is zero.
>Move this logic inside genl_family_rcv_msg_attrs_parse() so that we don't
>have to handle it in each caller.
>
>v3: put the check inside genl_family_rcv_msg_attrs_parse()
>v2: adjust also argument of genl_family_rcv_msg_attrs_free()
>
>Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks!
