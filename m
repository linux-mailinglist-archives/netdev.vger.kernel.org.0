Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245DA138461
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 02:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731846AbgALBBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 20:01:32 -0500
Received: from mail-il1-f180.google.com ([209.85.166.180]:39884 "EHLO
        mail-il1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731831AbgALBBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 20:01:31 -0500
Received: by mail-il1-f180.google.com with SMTP id x5so4935944ila.6;
        Sat, 11 Jan 2020 17:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UuKJPIkDgwTtD70ltTC++UTu+SdwSndYMdy/TpvjRxU=;
        b=H9URM5+3nnO4WnZPyNcTDROD7+KxIVrv1WNxfEZ2DeLwJ9r5MC8Akn6qyp5R/1i5i2
         PuUATQmuRwBV6ROaIi+HGcyuSgUWEOct9stelgjuA/rwnujYpvZbF3yMCL6MMEl41TYv
         5xUcGaz0Lb4oKDGcpIm6YQhOl7VTpEvvV/gKamA4dbaYJ3ipp2d9UApf1wNCvzCZN0Qe
         7WQMyBsznzdaKSV1vPzfp8Ep+wpcUdtcZU2+SPRVHueUCXZyjq/6y7XMwW3H2qNd0kwg
         goAoXyasd5Y7+m0pmSgSaIePYc0Bb4sZZH2rc+07L376tRz9vKVtXU2CSMMqCj7hmV8p
         dM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UuKJPIkDgwTtD70ltTC++UTu+SdwSndYMdy/TpvjRxU=;
        b=gh9G2e0nhKJ/7SJgniUVleDhdEFRn2FaKtgsIaaI0oj3/+MBubkLJVWLN3UNE84aX5
         LDVpPg1fqM39bncResQfAOTn/g7aXxeHN68cbeVWM6N9BD9xBJiXvbsboiHRsX1qvpOY
         cwPT70GnaLvGndB8nppBgpm5G8j5SLjtitYG6hRNE3FRiep76KG4EskV7sxSZnG1aB0/
         6/wJKy7jQLjjO3Fl6uFNjXKyIO6waIdk+uD8SojijNGd0MxCMD037+PRgxvP/+Eei/iI
         weVYZaSdJBnJKP8O0C74KS2bBbUJmjTWF92yivZpKttv9Lu2uzv/l8aPakB0C7jQxiqC
         urlQ==
X-Gm-Message-State: APjAAAX4FxbUbyeshJJDF2+SNHpZMeAhzci7633fPFw4nYHvRskWYgh+
        OCghvrisxdP0sYCNs0JfW+o=
X-Google-Smtp-Source: APXvYqwktZFR8ZN/ExT+TKIHN49pyCB3zNX7xakO/BYqkG389GBvZadwVc0XmV+09rv0aUU1CCquqQ==
X-Received: by 2002:a92:b744:: with SMTP id c4mr8639386ilm.34.1578790891450;
        Sat, 11 Jan 2020 17:01:31 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z15sm2252481ill.20.2020.01.11.17.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 17:01:31 -0800 (PST)
Date:   Sat, 11 Jan 2020 17:01:25 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a6fe51de9a_76782ace374ba5c0e1@john-XPS-13-9370.notmuch>
In-Reply-To: <20200110105027.257877-11-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-11-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 10/11] selftests/bpf: Extend SK_REUSEPORT
 tests to cover SOCKMAP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Parametrize the SK_REUSEPORT tests so that the map type for storing sockets
> is not hard-coded in the test setup routine.
> 
> This, together with careful state cleaning after the tests, let's us run
> the test cases once with REUSEPORT_ARRAY and once with SOCKMAP (TCP only),
> to have test coverage for the latter as well.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
