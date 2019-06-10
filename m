Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44F63BF91
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390388AbfFJWpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:45:55 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42697 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390139AbfFJWpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:45:55 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so6108325pff.9
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EOjigTvWdPVT6gCCvqoCROQTzRt/JKCSN3aOLcsbEH4=;
        b=ou2/NVgrUDGRoL2EAgXXyf1r8d5JspXMYL1/2kiMta2ssKtSYedgrlGgkbxVxtWmHU
         yooYWeItTyMOj2rNMT9DahX2GJIRKFvxsW1H40W9M5uXKbAYQSbG2ljIfXnJhDmXBFFQ
         pb18S0ycJmb5tu6ToZjK1DInYM62P1Q6OKMqWUY1ROOnfm9r0sepJu8ROEOlBaTCCUJe
         muli6PQ1jUaxNa0DJhcqsM/yn6bDApte9Q3QoytX7Aa9YI1HGW2ekXeHub4GQVrkDIMU
         Vr9rHeKDP1zMbm+3IDv9Dst+nRj3rQsbDFbwcWhN/gYv9/7VJUvWjY99RTfZXNaWm5Re
         PsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EOjigTvWdPVT6gCCvqoCROQTzRt/JKCSN3aOLcsbEH4=;
        b=rJFMPFW3pzar5lVOkZ78euKZwDBzzTPSlkYjshlqdDBY1DJiyn35xG66G5VYnIVKi1
         pXlHsuhkaEZj0rDqjNn+qGwpnDqPcEp1QSKJEBqdmf2itkmckXSztYlPFSHZ2iSHgidW
         Pyv104Ej4GRLoZwl7qz5h776sc0Owb+O8XFY9hbXf+lsZYre6awXCV31Nne+nhuh8XcI
         k5gq5G1HCxselbXMPOw6ZKJl78JT3GY6as88iNYFUMggvPofidPiyvMcJAhbC3+XiEuo
         G3MceCsY/HqM+HfUMMUOw1WIB0Kd9K8A8JVKQvTktqZuzBnC/AdSvY4qvf8T6xChQDfp
         mg8g==
X-Gm-Message-State: APjAAAX7uXGl25Xh4xcn3QzrjIkvSe4tsJQkNS+iahdJ1TPySZQwZvg2
        jKplLi/w+MScU1xkOesXEdoynw==
X-Google-Smtp-Source: APXvYqxO0VeO+f6RoxLDRbdu9MxrgqrBdXG7evEdtIBFkRQPluuq032Ou1PGBDrPfOYYoXUavgfk6Q==
X-Received: by 2002:a17:90a:be0a:: with SMTP id a10mr22355461pjs.112.1560206754926;
        Mon, 10 Jun 2019 15:45:54 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 124sm12535461pfe.124.2019.06.10.15.45.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 15:45:54 -0700 (PDT)
Date:   Mon, 10 Jun 2019 15:45:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2 1/2] netns: switch netns in the child when
 executing commands
Message-ID: <20190610154552.4dfa54af@hermes.lan>
In-Reply-To: <20190610221613.7554-2-mcroce@redhat.com>
References: <20190610221613.7554-1-mcroce@redhat.com>
        <20190610221613.7554-2-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 00:16:12 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> +	printf("\nnetns: %s\n", nsname);
> +	cmd_exec(argv[0], argv, true, nsname);
>  	return 0;

simple printf breaks JSON output.
