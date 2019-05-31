Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7793168C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfEaVTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:19:47 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:42080 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfEaVTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:19:46 -0400
Received: by mail-qt1-f182.google.com with SMTP id s15so2640123qtk.9;
        Fri, 31 May 2019 14:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ow7UxjHdCbtRy/ZODHP214ALaqShDnOlobjuYSm7vMg=;
        b=UU+G4RiXKCW2MCEoIrDFhXKEstNRb5MIcZL3GZZE35CUvzIjt6x/w2GphMTAfjNHhk
         Or5OlrpF6SjCtWCP0T3vIZhGYZcuNcnQYnhbV/v0UBNFXYOUGDwPzRu4BAga1I3SUqw0
         Jub1ZkPmGBoO/b6JyGcDF5NquMUfeFvZmP3kIky+cDEp6wbPE86n5eJNFAcHLQ5uoUYI
         HkwxdYkjFsA24NclhlvQDYGW3WvZp1DB9F7UsB4ItMSlptCwQneOhYqFJw2YUXVIbz86
         LFvyeGh2sfpcVm4ZErwVH6g9QX8nV1HxarUYWfuvePIDSM9lnzfSHFOD+FmidDoEl26d
         nJUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ow7UxjHdCbtRy/ZODHP214ALaqShDnOlobjuYSm7vMg=;
        b=OYRHkb3msnee0WA9UxqqMx7AegHwX/j70ye1NJ2kYIq7YIUxVrtdOS+Pl3W36BMGca
         JFCC8ArK4Pvj2zXDqT5fvn8nJ3EQPmF3K9znBmwH6IBnfEgO2nRtuzRRM5JV8iB7vaNk
         dNggvTIbe3qgjym+Lc+lvojSyOcQk6OR9fJSh+ZCGYyJ+0lZMLsfKUR6HVqyjGcBhRnx
         yJ3wcOwkHPIeph5RHY04QqAOfQ5/5JBFDhXaekS8NAeFiFohldpeqIQk5UhhAA6hChnN
         zDsfwNKae4jTHWSLz7eA82V6tOZY4BFpWAO4q4PxcHRONLvaPnK5bEwFUei3GGE/qYM/
         Hcmw==
X-Gm-Message-State: APjAAAUiWPuLJPEG62w1Vw17wvpvaNXyUJxIlKfw4B0V3tQD8oWpPard
        WkB5NO5hAXPDSLGTShv4Rro6GXwdAwwlGw==
X-Google-Smtp-Source: APXvYqwviQ3Li74a1xTBQeJGGD7H0jHFxTH7GIw0ZD4INvLIOeEAFwcVYJoeqS6k+SJYu+6NbKd4VA==
X-Received: by 2002:ac8:48c8:: with SMTP id l8mr10995129qtr.20.1559337585468;
        Fri, 31 May 2019 14:19:45 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.91])
        by smtp.gmail.com with ESMTPSA id d25sm435646qtn.80.2019.05.31.14.19.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 14:19:44 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id CE89AC085E; Fri, 31 May 2019 18:19:41 -0300 (-03)
Date:   Fri, 31 May 2019 18:19:41 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     syzbot <syzbot+6ad9c3bd0a218a2ab41d@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Subject: Re: memory leak in sctp_send_reset_streams
Message-ID: <20190531211941.GF3713@localhost.localdomain>
References: <000000000000f7a443058a358cb4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f7a443058a358cb4@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 02:18:06PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:

syzbot++
