Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE4ECB16E
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731784AbfJCVop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:44:45 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44443 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728763AbfJCVop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:44:45 -0400
Received: by mail-ed1-f68.google.com with SMTP id r16so3987097edq.11
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Yf5YJ520iQLkKoR1IUfpuHW8fgk0r5/nZ/EfDATS0jY=;
        b=seJlNLrhOwPTErgqWGH5pbQ5ei1WCCqf3195k9zcIN7ZOYinJFqRBbSyb8RkfsfDHU
         Gzzsg4OqerLSmsVYbZS7CvHq/7jKcu5RagZVe4lo4OhQ0ucpQA5TGL1IiySAOwWykhzx
         0sa7YH0paJPKVmZcNw6gslLm1lHmM4b3SvTpR0gcKs2xxHEThQbF6hfZUxz+YTmfrbG8
         iejHtrw+Psza8cwEGD8Mqzkr53CfD1AR3/qw3AU3OsDB2eQm4sPC9TBCp4+ZjFx8TW8A
         TEX6BmEMVUPqHYzbW0+r26ZU2Po9qI/YyqtzpVVFmx/+kVUGGQLyAwufhjb1zbiliPAx
         tKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Yf5YJ520iQLkKoR1IUfpuHW8fgk0r5/nZ/EfDATS0jY=;
        b=gRYoPcnKAWKjaAnBWxxjMjz/gk0w4BG28fAtrG5j6Kcl9cXkU3CZEHp/5pJseNRNjd
         HBp5PPwdlF/RrS7McPHrwv3lQSLbQRF74KKC+1hQXZ5mEcEQbi/trLCshhpmsmeHsLom
         WPAQcTQllCyE7T8dQS/dtWp9B/lqo1Tsp/XhYN9Dnw/wdVhPomqZSnFdHzbRVnOVzWMr
         EfQrSeY+Ph76S3+ejn9Bu+z93mQrDNzxcUQ0ZzD9QpcOGgpqnDRYP6+erdCVHeyjbwic
         W9AvUZD9hkCbdHW+aMG7+MGrt6jXheW5vzPJ5wUDYc8z/stgQVxaV65NZw0ru/hvADr2
         7kCw==
X-Gm-Message-State: APjAAAUvthkYGDttvFchB8iWEb7p2M6Gmk8lz+Y2sEboLaozA4jlFtK7
        ZC1QXOwYhaN+IDPGfVT/rFX3zfM=
X-Google-Smtp-Source: APXvYqwwr5dUJBU5xkIpp+zVpNg4rcCH8pungCzbmU/Nd6q2f30CRevdWDF33++IMhXW5ICHSbeIZQ==
X-Received: by 2002:a17:906:19c9:: with SMTP id h9mr9640847ejd.193.1570139082450;
        Thu, 03 Oct 2019 14:44:42 -0700 (PDT)
Received: from avx2 ([46.53.250.203])
        by smtp.gmail.com with ESMTPSA id h7sm693134edn.73.2019.10.03.14.44.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 14:44:42 -0700 (PDT)
Date:   Fri, 4 Oct 2019 00:44:40 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net: make sock_prot_memory_pressure() return "const char *"
Message-ID: <20191003214440.GA19784@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function returns string literals which are "const char *".

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/core/sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3493,7 +3493,7 @@ static long sock_prot_memory_allocated(struct proto *proto)
 	return proto->memory_allocated != NULL ? proto_memory_allocated(proto) : -1L;
 }
 
-static char *sock_prot_memory_pressure(struct proto *proto)
+static const char *sock_prot_memory_pressure(struct proto *proto)
 {
 	return proto->memory_pressure != NULL ?
 	proto_memory_pressure(proto) ? "yes" : "no" : "NI";
