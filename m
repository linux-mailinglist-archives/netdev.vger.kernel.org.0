Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F93317C105
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 15:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgCFO5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 09:57:06 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:37561 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgCFO5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 09:57:06 -0500
Received: by mail-pf1-f173.google.com with SMTP id p14so1239103pfn.4;
        Fri, 06 Mar 2020 06:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=HN/E5Tzk+girdr99QZwMRVL6lrNmL6Zp+J2fG5Cj+3k=;
        b=ZZJl1bR3mrcnaxL3ree8YW9dF2J+ItB2o9Jl9MI+gPGS72mSaONTdhu4Fc9JOF0A0m
         l5LgnnLCw/AXwPGRRAvTzotWYV9M0Dau6pmdQNhlfGtP1PCxmWxBwRpATq+sEY52RJSb
         +5aU8YUpZMcKnFNumLlZOvXnuzUCRPMXSPY1P/Hoha3+SlB6SBD8ewL05JB47mtJXrbA
         ZCt3E2vvFxyeUPVh5/5NTxEEeCXHebnLUHQK5fVyI6vCEcekoWr8FXdrFDXd4LL50WEk
         TYpkgnu8DOM8esTuuwZwKDrlB7ybdPZriAMJCJ7tXOx6mSV0/ozkf0c2vKjx+9K3EGzO
         H6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=HN/E5Tzk+girdr99QZwMRVL6lrNmL6Zp+J2fG5Cj+3k=;
        b=rI9v4dqKB0vkBK+oXa3kmv8ccqQE8fixlvbtcSpe1YB130gkpsxaXSmdseIy84VQMO
         RqaXBfKj8ewLaz1wA9toHprKuH5EFk4NDae/c0RhSRNjOcPy5cn+vfATyYFsUVJxMNxj
         gIkoQNBtk5SYhyRpkUBbCWelKUiUzsbJtfV1wtIkFY7Rq8tABigqPZqAbNOQTAb7ruK5
         05T9dVPCtcbknQPopU7fJmNNSp65eEvWjw23U+UkkMcuJNWgnZJDPs49ubVKFwKqTSNj
         9y75E72IfAL6u/iU2qDpu9WSrbdxQ7eGa2shiiep+5NX9oN02ESyTmKbgOND3x2J5Tzg
         AONw==
X-Gm-Message-State: ANhLgQ3rFgvgQ/7+Bflqor+locvSXzmC0RZZZU+IHt9fD49cg0by6EFy
        A01vE+EdwrJMTth47xZZGEg=
X-Google-Smtp-Source: ADFU+vsPFVmIpZRc3w2qNCFY2kJ81l3YLGJKsMVnjUcch/ZRlX58gTATWaB5boorNEsecw1muyyxVQ==
X-Received: by 2002:a62:1dc6:: with SMTP id d189mr4283745pfd.153.1583506624666;
        Fri, 06 Mar 2020 06:57:04 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d24sm37968572pfq.75.2020.03.06.06.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 06:57:03 -0800 (PST)
Date:   Fri, 06 Mar 2020 06:56:55 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e6264b766635_17502acca07205b46@john-XPS-13-9370.notmuch>
In-Reply-To: <20200304101318.5225-2-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
 <20200304101318.5225-2-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v3 01/12] bpf: sockmap: only check ULP for TCP
 sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> The sock maj code checks that a socket does not have an active upper
> layer protocol before inserting it into the map. This requires casting
> via inet_csk, which isn't valid for UDP sockets.
> 
> Guard checks for ULP by checking inet_sk(sk)->is_icsk first.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
