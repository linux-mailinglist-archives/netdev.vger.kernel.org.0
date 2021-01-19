Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26C82FC0B3
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389681AbhASUMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390961AbhASUJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 15:09:38 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63ABC061786
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 12:08:50 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id 143so23118647qke.10
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 12:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+j63nOA4y1xKSo4SCEY+cwQ+X5P4wOJlKbUG0Ffiq6U=;
        b=iAKuR3+nCMqzwR1VJMyV5RoNa0XeY8MFV4IlOR0LoYlFizfkhPfpoTk++BV1JmgWLt
         0VPR3+bemZA7YL9KdWYh6FUPPIt2yagMzi/en0QjJ70kRtjzdLcD9RZFEDUqlpn/DPEW
         U/IyALubsQ7Xup4WCPdYk/UegitXVYUiu5q98sCedKf0ZTuX6OVmZPP3JPOk6YydyNjX
         q4NuJkTVoG3AH3U023st1QuE+8+IV1ZrGWkcN765Ru+WMaTFMc6PlhDrq+7lxZnYgeIC
         +rCXOdyCASReeGrUBm9G6kTMy5gB2Vokv+w/CX1yy1kWuLP1tWzTLsoChRmwkeGCW08m
         BLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+j63nOA4y1xKSo4SCEY+cwQ+X5P4wOJlKbUG0Ffiq6U=;
        b=J6B2pjIhomNpA5nyACZ0BYlBSH0VBFHTq1FGONJDa16Y1WfvpAxh6PZ/2ZqoOqI0Rc
         ruUfACOxJmdmUbPl//Oz0IoKrO45HG9VADo8OdLt323Z1a5Q5Ux5MoIgFK1UYZhw5ltW
         65MFL1HBnbkwbYCpvjKuhD3geeY/nCSZOfuIjohfWN6OKKRZKVKtUofmHayhVTLw+HBT
         Gptd0+Eulh4W6SB+7VYGb6fM2Y+b0G37PbrfCrXkSFcGUWmd9C/9MMnq3wWPv1jNPh59
         8r7N9VQGCgxvFTlYIU75+Oj685sxv7kLepg3/7TdLFuJ+egOknS52CzTOdIYCWu6dThY
         Yz/w==
X-Gm-Message-State: AOAM531GTF2Asi4ixGpfOnGIZ6hMZU0KjdGZAl1w8oH0dZ3kdj6c+BUy
        RFo8DRE1BscQpDEFGB8py74iqxjEokjKfA==
X-Google-Smtp-Source: ABdhPJxN4Hd8ZjSP5k2Vj3xcEftfbC0LlNLd80HXyBKMdLzJJzmIFotmwypnET9TLQvg3p30sE2mvQ==
X-Received: by 2002:a37:2c42:: with SMTP id s63mr6205031qkh.87.1611086929767;
        Tue, 19 Jan 2021 12:08:49 -0800 (PST)
Received: from horizon.localdomain ([177.220.172.93])
        by smtp.gmail.com with ESMTPSA id t137sm11377182qke.127.2021.01.19.12.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 12:08:49 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 49A39C2CDA; Tue, 19 Jan 2021 17:08:46 -0300 (-03)
Date:   Tue, 19 Jan 2021 17:08:46 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] tc: flower: add tc conntrack inv ct_state
 support
Message-ID: <20210119200846.GB3961@horizon.localdomain>
References: <1611045299-764-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1611045299-764-1-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 04:34:59PM +0800, wenxu@ucloud.cn wrote:
> --- a/man/man8/tc-flower.8
> +++ b/man/man8/tc-flower.8
> @@ -387,6 +387,8 @@ new - New connection.
>  .TP
>  est - Established connection.
>  .TP
> +inv - The packet is associated with no known connection.

This is not accurate. Please write it after OVS' description of it, on
ovs-fields.7 (not saying to copy it):

inv (0x10)
       The  state is invalid, meaning that the connection tracker couldn’t iden‐
       tify the connection. This flag is a catch-all for problems in the connec‐
       tion or the connection tracker, such as:

       •      L3/L4  protocol  handler is not loaded/unavailable. With the Linux
              kernel datapath, this  may  mean  that  the  nf_conntrack_ipv4  or
              nf_conntrack_ipv6 modules are not loaded.

       •      L3/L4 protocol handler determines that the packet is malformed.

       •      Packets are unexpected length for protocol.

Something like: The packet couldn't be associated to a connection.

> +.TP
>  Example: +trk+est
>  .RE
>  .TP

Thanks,
Marcelo
