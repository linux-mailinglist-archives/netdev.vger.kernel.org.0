Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858A2EC6E7
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 17:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfKAQha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 12:37:30 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37241 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbfKAQha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 12:37:30 -0400
Received: by mail-pg1-f195.google.com with SMTP id z24so2261905pgu.4
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 09:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gOJ5XzVCBvde796e+t+/MgP1SJky3bny9Oe9WTHqW/w=;
        b=K2vqgGwbOiMey62FvoOVyP6nmrrHwiz8ldAAE7oN8QIAdE3jaaBrmj6hrktCEDhRaE
         wNgR/iTvK8nrCFyZRgsV5wqCpbOFvHsZPjq1FauAFATso5Hc3Oijak50DWakVK6vSFd4
         iKzmsk7EKpJeaPpEHnXKKQ/nKtyun38qbdI8cy6jeDhKeHkCU+dewsCvkyh8hcoVnn+1
         NkQsrLE1fb7mf9xJDtNRWBMO8za+nS79Itewg9lvRAW1pKKymgH9uELQvYsAcM7tsvns
         p8wilG4WGBjeYHl+Sw/6HQUq0zDwlmeke7hByO1Q7Zv35Gz5y/q0sl1LmrJfNPiaZPOH
         cceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gOJ5XzVCBvde796e+t+/MgP1SJky3bny9Oe9WTHqW/w=;
        b=qjLMF3d+RJMP+CBDK+jvsowiO8XlZpYiWVmcfRKcQkA4/0agxlGGCydk9pn92ZKIlO
         DWHQOZjS9N7ssv9Bq+9R0CFBpYxQSnuKPn+QrwkjsCraQVSwAR48jtl9zCvLffjLfqyO
         R0mmklQqnDj9Wp7mGwwJmqtAhgvcHStegzlstdeccjf+tkQwfh9Pk9VO63/bJFi6kHzp
         X1GXprqLcDbVAqtO3HweIX0gIxiGT5VmypZXiVZQ1WvAlb+NoNR+eEj4A52FSry+9+I9
         KfogptKzg4OqrgwukQpt7gGSNvdwPDmQMiStYB2HbTd1/8qesemH7CzYrFzy+cg/6SJw
         aX3w==
X-Gm-Message-State: APjAAAUEozXqqsNFLc50BEJZlobsBc4lNExqzXa8KPVoIsHYuqb9XfMO
        e7+Bu6TI7zvFE/CfQfTmbbPqYVmQkieZPQ==
X-Google-Smtp-Source: APXvYqw+hlIb9lZGMJJffGOdcrp9969sPVnknN03mXU9c1UEU9I3PF8/z01pAxBqmoj2lyBoGug1ow==
X-Received: by 2002:a62:ee0c:: with SMTP id e12mr14128047pfi.262.1572626249277;
        Fri, 01 Nov 2019 09:37:29 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m68sm7154571pfb.122.2019.11.01.09.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 09:37:29 -0700 (PDT)
Date:   Fri, 1 Nov 2019 09:37:26 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mleitner@redhat.com,
        paulb@mellanox.com
Subject: Re: [PATCH iproute2 net] tc: remove duplicated NEXT_ARG_FWD() in
 parse_ct()
Message-ID: <20191101093726.6c867e96@hermes.lan>
In-Reply-To: <20191029175346.14564-1-vladbu@mellanox.com>
References: <20191029175346.14564-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Oct 2019 19:53:46 +0200
Vlad Buslov <vladbu@mellanox.com> wrote:

> Function parse_ct() manually calls NEXT_ARG_FWD() after
> parse_action_control_dflt(). This is redundant because
> parse_action_control_dflt() modifies argc and argv itself. Moreover, such
> implementation parses out any following actions option. For example, adding
> action ct with cookie errors:
> 
> $ sudo tc actions add action ct cookie 111111111111
> Bad action type 111111111111
> Usage: ... gact <ACTION> [RAND] [INDEX]
> Where:  ACTION := reclassify | drop | continue | pass | pipe |
>                   goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>
>         RAND := random <RANDTYPE> <ACTION> <VAL>
>         RANDTYPE := netrand | determ
>         VAL : = value not exceeding 10000
>         JUMP_COUNT := Absolute jump from start of action list
>         INDEX := index value used
> 
> With fix:
> 
> $ sudo tc actions add action ct cookie 111111111111
> $ sudo tc actions list action ct
> total acts 1
> 
>         action order 0: ct zone 0 pipe
>          index 1 ref 1 bind 0
>         cookie 111111111111
> 
> Fixes: c8a494314c40 ("tc: Introduce tc ct action")
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied
