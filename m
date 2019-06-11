Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0343CAF0
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 14:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390249AbfFKMRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 08:17:38 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40840 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387891AbfFKMR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 08:17:29 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so14167978qtn.7;
        Tue, 11 Jun 2019 05:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GSXqlyZidmMQ8MOHJEGBcV3Wql47aTHhWc436NDzu1k=;
        b=Q7Gyh0Qd4eQz7NWls6kFS8SAd80WG5XRG4LGldAC3beTSo3Cx34FwvRJK5fAUbpx02
         WCXhq7j3seBRVyFb8nb/XJ8gBBoDzveW6yIswOoWsTpVRfYhQmHYTiMASM1g0PbFuaqp
         n5j16YK8Sfws5dCImnf4oykGMQkBbjiNru9S/wxxQyMgXRsgxXtTb1yFi5LRSYk8cvRN
         wYIUNB51KJc9zyhLC+CQY8nYD/wuTrKdwdGR8D4MhpD8Mu55QJQtN95ESWLYW0gdMUux
         PL1pDtGGADOfdNeTMGagbOSTOcGWeYv8uqoNw3wnz1Pfut+kKPgp+v5X6PVuHXZtsGdx
         2Oyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GSXqlyZidmMQ8MOHJEGBcV3Wql47aTHhWc436NDzu1k=;
        b=cNvao2oZiqQ591osPm8CzwOeyGwsD4gz5Shb3sYjamZMw1mkIfDqPHrx/QXHp9hOHX
         YDRMG/qSe+Mbq6C9YGbyqR5IZ5/9JzDvdpi4bRMg3Dd8oCeZsNEFZh/QTE7VEPa/u478
         /sWJ4hYlj+JwCjsOSUmaDP3dczGKzgcgt/jwj7eGg9pf7bWnzFRxmdqNRuG/jRkXmn3k
         7FzK9X5onPY+HW26sxRBbpodlI/JHpBIVxf2gJrK7QscO8hSDCB1OAkCLnGWLZlXE705
         8RI4aliOj1cBg6pLnpNr2B6R3N/WPSYjiW2zabSOUTalZwxQ5+zPKy5ptq/M7hLFP8yy
         a5eg==
X-Gm-Message-State: APjAAAWwssKo8hF8kueCTK3JuozCp75dFy1GbHYQnzzCaozPhi1skOFG
        gHNqSZc+TgPlIJotT5Mo3H5q77mfvLo=
X-Google-Smtp-Source: APXvYqxmM4OceIAJCFzmaSCTmQw9pZg2mf3TMYLeECP7Ef6amdFzcBEHFdKABHZm/mnoXszvUXow5A==
X-Received: by 2002:aed:3b25:: with SMTP id p34mr63364121qte.289.1560255448474;
        Tue, 11 Jun 2019 05:17:28 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.36])
        by smtp.gmail.com with ESMTPSA id q36sm8815468qtc.12.2019.06.11.05.17.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 05:17:27 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 9E7D3C087D; Tue, 11 Jun 2019 09:17:24 -0300 (-03)
Date:   Tue, 11 Jun 2019 09:17:24 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] [net] Free cookie before we memdup a new one
Message-ID: <20190611121724.GB3500@localhost.localdomain>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
 <20190611112128.27057-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611112128.27057-1-nhorman@tuxdriver.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 07:21:28AM -0400, Neil Horman wrote:

Btw, I guess DaveM had meant to add "sctp: " in the subject.

  Marcelo
