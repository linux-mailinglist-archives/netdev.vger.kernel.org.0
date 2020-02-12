Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024B315A1FD
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 08:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgBLH2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 02:28:38 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45737 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgBLH2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 02:28:38 -0500
Received: by mail-wr1-f68.google.com with SMTP id g3so859573wrs.12
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 23:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fUIbYXq+XmvGG5vVImxvU+kik8y+kWLJIbX7dbSMfm4=;
        b=NbezMxwn4pldyKyx2zEZ3iIUKAw6m+LU9K/+uS4WUu4iACuh1uC94w7voItzSlQpCG
         vut64QERPbWo2TM5+G3a0HQYoUTEfo38DfbMZClrvx9cBBs5PJQxphfphn/iJ4sbe0b9
         wDzKt4nCMDe7Cv/p86I/IRUKxBRG46r97BJ8vI5u8O8mvhvPg9wxXBDLJHbsdS5rScAE
         N1142L1+uJQD/uG9BXyvzbfkaR04PlmlkLoKgRQ75GkZ796hlQ6q8059TSPqEHVvtEcX
         HkOtp/lChjbsPtDzw75uVmZOijQbTQVTApoyOmKLt89GUXxIOuHt8F7h3lm2/wbz/eeG
         11tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fUIbYXq+XmvGG5vVImxvU+kik8y+kWLJIbX7dbSMfm4=;
        b=jU/UYwzTWiKv4b6OYrxh2I/BG8UbCe1sqz6s3fYWlf1lpwDlZsB+YKwiWnmq1xXQ5E
         sSpxWxhVg2qTV3d4/rrJDTeAsClKf4va3zPs1At8OLXJaGJf6h2q+CQ9dwxZfDkY7ohH
         IH8bZ6V4AK+3aU+BUvjqx1tE1KFhrddXeE70yfZxjx7i92iBDDyU6u/dEv77tRKC1LKO
         XA4Lb01jZdR9N3GJgAkdloC3rg50cG0ZwNL9+TvBPPVCzkp5A4ou42Acl5HHYkgGT4rH
         LNpOXV7PpxfrTwiAJ9a+rOcueE+8FjcXivCY6G01cZ5b1lD6W5eyyZkP111LVS0ZsNuS
         D6Hg==
X-Gm-Message-State: APjAAAWgMljvYvl6y8E23W2pIHH9xGLkNxMJZ6nqNMbEQvIaZPStOccH
        MC3oAwimLVeLedm9IXRn8eJkNQ==
X-Google-Smtp-Source: APXvYqzNhBhMOb74+SLOqQ4WcJLPaQOO6/8C0RCI/yRuMr2JRfkKvf2umsdCdAvzYYO8y+7ngfM5mw==
X-Received: by 2002:adf:f692:: with SMTP id v18mr13940681wrp.246.1581492516170;
        Tue, 11 Feb 2020 23:28:36 -0800 (PST)
Received: from localhost (ip-89-177-128-209.net.upcbroadband.cz. [89.177.128.209])
        by smtp.gmail.com with ESMTPSA id b13sm8808563wrq.48.2020.02.11.23.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 23:28:35 -0800 (PST)
Date:   Wed, 12 Feb 2020 08:28:35 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Amir Vadai <amir@vadai.me>, Yotam Gigi <yotamg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net/sched: flower: add missing validation of
 TCA_FLOWER_FLAGS
Message-ID: <20200212072835.GC22610@nanopsycho>
References: <cover.1581444848.git.dcaratti@redhat.com>
 <6f39f0296c4cd7b339764c863cde8fdf04b83ec6.1581444848.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f39f0296c4cd7b339764c863cde8fdf04b83ec6.1581444848.git.dcaratti@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 11, 2020 at 07:33:40PM CET, dcaratti@redhat.com wrote:
>unlike other classifiers that can be offloaded (i.e. users can set flags
>like 'skip_hw' and 'skip_sw'), 'cls_flower' doesn't validate the size of
>netlink attribute 'TCA_FLOWER_FLAGS' provided by user: add a proper entry
>to fl_policy.
>
>Fixes: 5b33f48842fa ("net/flower: Introduce hardware offload support")
>Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
