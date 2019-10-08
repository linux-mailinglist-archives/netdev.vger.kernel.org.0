Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022ABD0440
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbfJHXkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:40:14 -0400
Received: from mail-qk1-f174.google.com ([209.85.222.174]:46043 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfJHXkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:40:14 -0400
Received: by mail-qk1-f174.google.com with SMTP id z67so492634qkb.12
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 16:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=W2bXhmTOSd1/unXSE5hxivBLejKDsoLiWhaBevi5yVU=;
        b=P/sSZi6UbyAaVGkHl0XoNp93LZsBBfYfDFg+lLgpU3hmXK6oQIm6GLrEyfiolmCybW
         OeI4eJKOzNCF1qzbk+phSVW3q3Qm9ShQ4wRQqsi33N2IV0TJRin4rYp348AL46ro5+KF
         8i3WNbuJQeQd3E348aD5tMPJzKxl1RMF8+ugC2poWJWmI3CVvsWJXcQRy445Pz8bGsc0
         buv381oOwRHH5vWzviuktL8YR2qw+US1YIWE4bVMiTGhRmboNEcMDw0aMdKXEpezpizZ
         srySoWyexdh/0ud41CHeQZ8JBEaWcOXuSCyHVxPM8bZ1JSRkcXhrfhDKo5ydyNStAQe+
         1q+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=W2bXhmTOSd1/unXSE5hxivBLejKDsoLiWhaBevi5yVU=;
        b=Wsmqgr1ulLHjLDIWF2jHKj58JyF1O8zaUr6D5f3KF8kQyY0oXjzLD457kNnpobNq9X
         t+2d/EfpKO85DenXmllOWMOQ98iaufjdx/oHnyFW54UcIhgmbe1W0BtZZCaws8ypSn8T
         heOFcFk2pIWzb8D4epCYULBdn6DS6zxRrIVEpTcr/L9Z0IjW+dkZqs6DBWCmzzWU1Qs1
         XEdkJRNjXuhTYLfEy2mOiVEx6xKJXzsvHcAOA4x8Y3u9HgQnU+1EyL0OLXUQmE292Wyt
         +llQkook4VbERX2r+3uwH16KT/0ksbk6eB4p4mReKqCX5JW2iIqhqbM2NkW96Hn6scjT
         Ybig==
X-Gm-Message-State: APjAAAVMP3giEPu6Wom2MNaQ1L2POT7cH6Yd2i4vFJAZGK9wo4lYyPDH
        ZQqMI+4JBr3+7r88xKhTP6ZKjw==
X-Google-Smtp-Source: APXvYqx4l4aUETb0S1tGb3/61m1KTEHYjBSlfVlKAXj5lRIXfB+0KDN41pm7bQBLTK4wNm5FkumF2Q==
X-Received: by 2002:ae9:c302:: with SMTP id n2mr780658qkg.69.1570578013294;
        Tue, 08 Oct 2019 16:40:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m186sm129171qkd.119.2019.10.08.16.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 16:40:13 -0700 (PDT)
Date:   Tue, 8 Oct 2019 16:40:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: fix backward compatibility for TCA_KIND
Message-ID: <20191008164001.7c07fa9a@cakuba.netronome.com>
In-Reply-To: <20191007202629.32462-1-xiyou.wangcong@gmail.com>
References: <20191007202629.32462-1-xiyou.wangcong@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Oct 2019 13:26:28 -0700, Cong Wang wrote:
> Marcelo noticed a backward compatibility issue of TCA_KIND
> after we move from NLA_STRING to NLA_NUL_STRING, so it is probably
> too late to change it.
> 
> Instead, to make everyone happy, we can just insert a NUL to
> terminate the string with nla_strlcpy() like we do for TC actions.
> 
> Fixes: 62794fc4fbf5 ("net_sched: add max len check for TCA_KIND")
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, queued for 4.14+, thanks!
