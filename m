Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BDE6D235
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 18:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfGRQmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 12:42:44 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35372 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRQmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 12:42:44 -0400
Received: by mail-qt1-f193.google.com with SMTP id d23so27908446qto.2;
        Thu, 18 Jul 2019 09:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=4CGjHe9gyIPjt/RWxr4GdT0SxBdQV+yCHgwdi8NU7/Q=;
        b=tRBY9axWhMbG3+yDbY0YQAisXFNyCJHvwNCZzMtfh/fgSBQ3C0lubunuVOT5DUNPRp
         QQuG8P9bVxaDDiaBb7inG/W297L1McqY3FAMMknlc7ex5aKgtsuB1GhVVFS5A39uK0rD
         zkD6S9SajdhQufKxIvIUaEI4DQBjJdW8EOqqjIbArf2ZdWfAShdHZvvqkz9g10JZme01
         hYq5u2xncXMyBYvbVrvbv7UaLF1V3JOfS0nGsJZb1c5SD4BaxgpI7xkmFuA93NHdlcnq
         qF1HKPb6GPeW87it74rBzvySlfqWkQg8u/qF6Id16X/lRobDF+1EjfPyjUFqLNFUSxGc
         /YtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=4CGjHe9gyIPjt/RWxr4GdT0SxBdQV+yCHgwdi8NU7/Q=;
        b=SuD4uWcMcWI/lUt10Yl/5JKgVOTmjVZ5dRC3K+ZrX5/8CJZ+LTovLebQwCG1Lle5gw
         P7CpI7LjCfyS3xlzKxBiJ1mzL5T5oAWkhz8f/XuNZYV/T+fCvuarhn+n/PImYBzD5+qd
         n2rcRyQi8H3Ee3WN3IgP2J9yknDomW4OKdwTtl47C0hX6cmwnJPQi1BmBxKNZoGDcE19
         MqbsQedXBFo/GTK4lbGzsfj0pu3NBT64q4iJSouFtcmcxIPaUcA9mkD6x5Wq5NTq8FcC
         PXl90vOJa9LgFVGSuBYw43gEugO1IWKK816Rnp6TttgwZCRDjDa6gMKEeu+4MHeOewZT
         i7Jg==
X-Gm-Message-State: APjAAAU0R4UvgNxmE22C33IEquIfr0FbOnKxC3u3x0SiHwVhSg0Y6Cu9
        gWYVGnPo+f/SfpgPuubpK18=
X-Google-Smtp-Source: APXvYqyB0YvtRypyM6/wPEMUY8vCtSzJD3uKae20TwJ093xCMzOzN2ez3V4tPDzkDgZREpaA2AWStA==
X-Received: by 2002:ac8:28fc:: with SMTP id j57mr30941483qtj.330.1563468163102;
        Thu, 18 Jul 2019 09:42:43 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id v17sm15992102qtc.23.2019.07.18.09.42.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 09:42:41 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:42:40 -0400
Message-ID: <20190718124240.GB5644@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: dsa: sja1105: Fix missing unlock on error in
 sk_buff()
In-Reply-To: <20190717062956.127446-1-weiyongjun1@huawei.com>
References: <20190717062956.127446-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jul 2019 06:29:56 +0000, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> Add the missing unlock before return from function sk_buff()
> in the error handling case.
> 
> Fixes: f3097be21bf1 ("net: dsa: sja1105: Add a state machine for RX timestamping")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
