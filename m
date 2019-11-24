Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1678310824D
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 07:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbfKXGE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 01:04:58 -0500
Received: from mail-il1-f170.google.com ([209.85.166.170]:40462 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfKXGE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 01:04:57 -0500
Received: by mail-il1-f170.google.com with SMTP id v17so7319493ilg.7;
        Sat, 23 Nov 2019 22:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/ZB2vo5mMwx9GNgoHDWNljnl84/sVVrzRimwZUup6HA=;
        b=OSIL8T4ID4KcM/0E7n8W8ZHm3bwj/lO6JjletSLZFcYk6tHVg6Ch7LusoqL0CEjUl7
         xZtDW836r3zaVX8PbvvnRpAZ28udfUgbwm/8bhS9SQ+PYp8XpqRegDNblJcgR0ddWisv
         cMx6veWWzNjImK7KwtWIE2jhpMONrPGqXiJ/glrVa7cCwwptXVPRHjjK7wZD/y8EdAo3
         59I+XuoPQdgu4Vcq5axlpV7xC6OO/XseXBf67QJKd8wEIFkxEC5hsbOjl2ASsHZIp+M4
         pXl74PuzQEVQ+RuSl5wk9DEtMVG1u+9tdPfnHIRYITshLhNvB8LIz2av35xVvzaxTNwM
         9qmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/ZB2vo5mMwx9GNgoHDWNljnl84/sVVrzRimwZUup6HA=;
        b=dumijMANh0akiCia69q/RfUU+z4YPracNJNbtOiz2+WdOjT6gigLELJYBQIkqMEtNs
         w0AREwbiy9pupOaaJdWEXtYS9/wianbxbW9B6D+oCtiEVSgtKq8zsAcrNlbRSr4AibzG
         7E448sZuR6uIDytuvq34Dm3tR8n9hBbjmum01ZNJOXyB3Irg8Q1BDM3ne07UWItcAU/W
         CYu2gnnMYwURqYvXvFelAgRKHVv4l1LJdzvD7NLgSJQyhUnUL1rN83U7fl9j40Dl3poG
         BxEe3wFoIl6xRDMhzxHhQnq38WYDqgCOueB3rQEQxjLw45U+3OkqTw87yBHWiHSrfjx3
         DKwQ==
X-Gm-Message-State: APjAAAVKYJSt+WWekbzav4AZOce6u3M9AUlprnCOTSCpMQP2GMfJInUY
        AHeI1b+IaXw+7/Oc+gvUj7w=
X-Google-Smtp-Source: APXvYqzGQ2FcKc6ZmC87cVLfdHWoOlmlFmSpW0aLWr5SpEpwsjmcIajURu//CgFXR69yNL1Z2depQQ==
X-Received: by 2002:a05:6e02:4d2:: with SMTP id f18mr26184354ils.270.1574575496842;
        Sat, 23 Nov 2019 22:04:56 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b13sm942822ill.61.2019.11.23.22.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 22:04:56 -0800 (PST)
Date:   Sat, 23 Nov 2019 22:04:49 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5dda1d817155a_62c72ad877f985c428@john-XPS-13-9370.notmuch>
In-Reply-To: <20191123110751.6729-9-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-9-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 8/8] selftests/bpf: Tests for SOCKMAP holding
 listening sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Now that SOCKMAP can store listening sockets, its user-space and BPF API
> is open to a new set of potential pitfalls. Exercise the map operations,
> code paths that trigger overridden socket callbacks, and BPF helpers
> that work with SOCKMAP to gain confidence that all works as expected.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
