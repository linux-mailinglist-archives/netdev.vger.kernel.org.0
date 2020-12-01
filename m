Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F94C2C9419
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgLAAjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbgLAAjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:39:48 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CA6C0613D3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:39:08 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id v3so89284plz.13
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IMViAHppPt8SsjQP5Bea2uwYvXc0JkYE37wOjlL4OT8=;
        b=Ya7BmhrK62z3vegpipnjpodioz3VRN7PiyhUp+XzgrHOJxmP0sVPSmqIq08TLa5W7Z
         5hBiW+JDksSURduvaReh5DoMYwu9XVyJVO2U3EB5WvBXk5idpaKqxGSI6oprxrm7NX+E
         mw4HbyLNSKNHteJj823zeTbNhB8L0Atk8ruy/TLE2nvfKSkqduHIZTQGFbM9yf5nitfR
         4/kUQ0zaau3zwIJcqzN45nmoQt4iQ0+nHQng/5o8sWgY6OFHp58Sh6PFNvpfaT95H00V
         7Xbb2zctXhrk7F5O2A7vO4S3vlkUHNAOm+ZOlETJ0GY2qUEMAQAFpqzn3HB7sZV2Neu7
         I7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IMViAHppPt8SsjQP5Bea2uwYvXc0JkYE37wOjlL4OT8=;
        b=MRMFpAv7JWfNnP2oWFJTtHxgO6Mmb4DA3B+c4kjE7WEC7dK9M5Ot05ADiBBsqFsNgQ
         DRVbfd8gPqEZJaKeqDdyElso/YX3fGVzu2WyjPAsOhdDl4VlchmVEgtwu9TL3ZE5g9PO
         koH7p3Ydx5VVueiIetDk0lIOY+4TKYo9if60sgrX2Uwmy9CR6Otrv1Fzd/guIOEHJg8Q
         Ii9dFlsstP+2uLd3P6uKC0QXx3utgTtm/TwNmRcFA3lj/5emACyQbBHV7mn07ZyVowNN
         8TMWvxITpAgXMFrYLiPDw8STvxKmUKzffyOWFXJSEQuKuQeCFSJIEFsMDjFzATAZ2etg
         6Ifg==
X-Gm-Message-State: AOAM530HTqQ6DsX7fMpd8i3X86B9lm0wPFaoD1yNlQCeURmXNxWdLTn0
        UL37XMeV0aymD+5otbRAIzXzhA==
X-Google-Smtp-Source: ABdhPJx5hLXbuV1okK5bAiekIJpRYVeDauA5JjX1TTE8fXHjuS++9qgUFdf2/+pz5UUv7kzhUqUFfw==
X-Received: by 2002:a17:902:9894:b029:da:5698:7f7b with SMTP id s20-20020a1709029894b02900da56987f7bmr273355plp.78.1606783148279;
        Mon, 30 Nov 2020 16:39:08 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q18sm145458pfs.150.2020.11.30.16.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 16:39:08 -0800 (PST)
Date:   Mon, 30 Nov 2020 16:39:04 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <me@pmachata.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, Po.Liu@nxp.com,
        toke@toke.dk, dave.taht@gmail.com, edumazet@google.com,
        tahiliani@nitk.edu.in, vtlam@google.com, leon@kernel.org
Subject: Re: [PATCH iproute2-next 3/6] lib: Move sprint_size() from tc here,
 add print_size()
Message-ID: <20201130163904.14110c5c@hermes.local>
In-Reply-To: <96d90dc75f2c1676b03a119307f068d818b35798.1606774951.git.me@pmachata.org>
References: <cover.1606774951.git.me@pmachata.org>
        <96d90dc75f2c1676b03a119307f068d818b35798.1606774951.git.me@pmachata.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 23:59:39 +0100
Petr Machata <me@pmachata.org> wrote:

> +char *sprint_size(__u32 sz, char *buf)
> +{
> +	size_t len = SPRINT_BSIZE - 1;
> +	double tmp = sz;
> +
> +	if (sz >= 1024*1024 && fabs(1024*1024*rint(tmp/(1024*1024)) - sz) < 1024)
> +		snprintf(buf, len, "%gMb", rint(tmp/(1024*1024)));
> +	else if (sz >= 1024 && fabs(1024*rint(tmp/1024) - sz) < 16)
> +		snprintf(buf, len, "%gKb", rint(tmp/1024));
> +	else
> +		snprintf(buf, len, "%ub", sz);
> +
> +	return buf;
> +}

Add some whitespace here and maybe some constants like mb and kb?

Also, instead of magic SPRINT_BSIZE, why not take a len param (and name it snprint_size)?

Yes when you copy/paste code it is good time to get it back to current style
standards.
