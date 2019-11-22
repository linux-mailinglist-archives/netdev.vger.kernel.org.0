Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101CF1075E4
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 17:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfKVQgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 11:36:53 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:43296 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVQgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 11:36:53 -0500
Received: by mail-pj1-f67.google.com with SMTP id a10so3248187pju.10;
        Fri, 22 Nov 2019 08:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=D+UWHveIo6FHihN6iLKYJHZLO5XGbq5iDrl2TrjPdEY=;
        b=NudE6m8b0+C+lesIyiJH3cHlgQpOtb7ed8r1UbZEKDp1CojGwyAuVqi5+C4HahBwYI
         XXIjTX+l+hI/0RBqOcx9Lr9UnNyETGfmX1GNzSxWe0TAskD4zPkJQoiYxgg4TpDRNscH
         oItXkG+61ojThm4Zc6eYDlB8fezXD4IShCECXE70Esfd6Ed+UNTpJjsdWt4CJchHJZzo
         1PdmYpFmR/T2JnzrKEK/7EZb9AmaorQurRGRNK2BPMTiJel7Qtr4oo+KAlkzBYzwZ93+
         OGyV3SKNUHfoykoAhgE4Vk3bSTZJe0wbN/sj95nGqORZZ5XrotjM4+ywa0CEJJqwRjMc
         oThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=D+UWHveIo6FHihN6iLKYJHZLO5XGbq5iDrl2TrjPdEY=;
        b=kr2yg4kJv4KNjjll4BR5Qjq7udBcDKHmNc3hjyN/tDppCm7yV4DQZRdVNWjjhdPbuM
         xESOHvGMxruB5ZrEA2NBcBPf6nry1QoFy6iHRVd+598uc7L2oENEl6PWonEkORolIUa4
         V4qfAABrXsRrY1hhagXxK5CEuoL4tn7wH1byVboICTOS814fgSF2QooeE42Upx26HhV5
         univh/2D9BV7hAgjl1xVUOoeczBoWXNX1jhY+ORc67stehZEM/2MU+dZLSYiC5QIf/Ta
         c4gtVBFRGVXNrJu+Pcd+OoFWh+Yz5TzTQExiIjpGS8VmMEhG8EDh5b2fahi7mkCSlYAA
         NdpA==
X-Gm-Message-State: APjAAAV6GGknY3moUNksnTXRSfWK4tU1EDYWvDCNaVw3THRbkSGcRYWH
        XCH3PUEDTmKlXN7A5TUjrYNdxbyU
X-Google-Smtp-Source: APXvYqws9YfhwJnhkMkfv47bbUMQRwV6BMlkFaWUN509dm0p7EiIO2UfHYvaXH/eGf7zsaWTMvwbow==
X-Received: by 2002:a17:90a:25ea:: with SMTP id k97mr19433680pje.110.1574440612634;
        Fri, 22 Nov 2019 08:36:52 -0800 (PST)
Received: from localhost (198-0-60-179-static.hfc.comcastbusiness.net. [198.0.60.179])
        by smtp.gmail.com with ESMTPSA id d11sm6612582pgq.67.2019.11.22.08.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 08:36:51 -0800 (PST)
Date:   Fri, 22 Nov 2019 08:36:50 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Message-ID: <5dd80ea2da121_690a2ae784a225c44f@john-XPS-13-9370.notmuch>
In-Reply-To: <20191119193036.92831-2-brianvv@google.com>
References: <20191119193036.92831-1-brianvv@google.com>
 <20191119193036.92831-2-brianvv@google.com>
Subject: RE: [PATCH v2 bpf-next 1/9] bpf: add
 bpf_map_{value_size,update_value,map_copy_value} functions
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Vazquez wrote:
> This commit moves reusable code from map_lookup_elem and map_update_elem
> to avoid code duplication in kernel/bpf/syscall.c.
> 
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  kernel/bpf/syscall.c | 271 ++++++++++++++++++++++++-------------------
>  1 file changed, 151 insertions(+), 120 deletions(-)
> 

Nice bit of cleanup.

Acked-by: John Fastabend <john.fastabend@gmail.com>
