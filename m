Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355E99B4BF
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391220AbfHWQoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:44:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36549 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731416AbfHWQoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:44:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id l21so6064392pgm.3;
        Fri, 23 Aug 2019 09:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9FkUWk2koiGP5t+9Cf7hM3Mv8GQDSr7QcD1deZ+CtUA=;
        b=WoXi66Cy/8h3WQlSYkDuJd08D3y+EwGmLF6zg1ssIE6ghxJJMttFeoWRYgAi3AHpCo
         rP6rcdZheID2HOokxsopolXdYld2c4ngprE8Y1lRENOyVVPQgu/eB+cRqjJ1c5NjKhyb
         qmj8MAcue43N8XqojU5ECkndLwpNXRZfk+Fw27233yBjk7QQ1H9MQ5Pfcdzqll0TFCcz
         VUeuE6RVei2TsEMMlyYiEZSfw71L+mHO1NskN2i3SwhSwSvQ9ytdGHhWZR8hqJux2I8K
         3hJMv+egsfj5KIiSs0m7z4E8VTKDFdPhXTsNm7SCTio2t8vO0x0vkJ8MHqFQmPYowlxu
         7u8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9FkUWk2koiGP5t+9Cf7hM3Mv8GQDSr7QcD1deZ+CtUA=;
        b=oJ8QcyLCEPf/sHyZu69hOEoI5GsCCZd8myWzZ4gRrG/T4laKI3rx6l1oVfDFJmeEpM
         IyjtedarAw686gXsGvSx7OzCLtTfdLGB/R4Zf8X0jz8qFNiVqzc7oOzCs0FdbNdIC2XO
         WcWV2523uWMkHmMsAFjckJoTvQ1MdOjHUu8K5FMtjvxEM/ZGC17NPA4OujKn2IeLf1BA
         CiIpVQGWKoUoG1OlYONHs0mB4JpAeCZqoco3PwgqUxPACh37qLrc6i8Emw0KVxvIcr4Q
         PRaCpnB8ssMGNrNWu311UFpRDGBrt/ub+ul0GGom8OuGlpU9xx5H+vfB3jjGaUhAA9QS
         YKIA==
X-Gm-Message-State: APjAAAV0+E7iYYkeOtEsVQpSoJ4ZbwyA8qiXyJBYh0y6kOUn0fpLIGv+
        AphlmmP4ENZ5WPO/6hJRxVM=
X-Google-Smtp-Source: APXvYqwBYD9EroZPyISbuH/pTGIgLC93zLICmPmkDYONWc77rpBu4jNWTjPetr04gMD8V0sG4/qEDg==
X-Received: by 2002:a17:90a:c086:: with SMTP id o6mr6437568pjs.2.1566578646063;
        Fri, 23 Aug 2019 09:44:06 -0700 (PDT)
Received: from [172.26.99.184] ([2620:10d:c090:180::b6f7])
        by smtp.gmail.com with ESMTPSA id bt18sm3017029pjb.1.2019.08.23.09.44.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 09:44:05 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: Re: [PATCH bpf-next 3/4] xsk: avoid store-tearing when assigning umem
Date:   Fri, 23 Aug 2019 09:44:04 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <48E7E6D5-B50A-4431-9200-EB23B14BB952@gmail.com>
In-Reply-To: <20190822091306.20581-4-bjorn.topel@gmail.com>
References: <20190822091306.20581-1-bjorn.topel@gmail.com>
 <20190822091306.20581-4-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Aug 2019, at 2:13, Björn Töpel wrote:

> From: Björn Töpel <bjorn.topel@intel.com>
>
> The umem member of struct xdp_sock is read outside of the control
> mutex, in the mmap implementation, and needs a WRITE_ONCE to avoid
> potentional store-tearing.
>
> Fixes: 423f38329d26 ("xsk: add umem fill queue support and mmap")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
