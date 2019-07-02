Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2EDA5C8DA
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 07:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfGBFgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 01:36:55 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44557 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfGBFgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 01:36:54 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so34173046iob.11
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 22:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TMu7+m+EMtKVDQlNqYQt4TIJXdlcb/bp1RTy7lrABAo=;
        b=xCU4smhi8YkwW1IUC7cTxNJHgXgDo7cm2L5NdlfY3XmLIUFgVzU2szS6ENhCxJAD12
         Dx9NSTYZUDC7eD8eFlAP+O6dsYZ8wzR6QMOe0XJR3ixozMAWtY6Kv8VuqmkGbB5PTGGY
         ZqCJ0PQK+mbAC1M8ZoZrNmckVic00JGsv3sEgWbkCOomeLI66nUtOIGR/bU9+auh4g3h
         MU7LgteVAB9p/tXR8zN+2sUq8OrbqdO+sXC6nua7lAMctPqo2MTKygcJPCgELLlXSFwN
         PULdi3jKVTzqINSTKxmqfebgfw7qv7zGP6QcUd32KvOXkLXbwgdoCpJeg/O6wpQsRSA2
         p3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TMu7+m+EMtKVDQlNqYQt4TIJXdlcb/bp1RTy7lrABAo=;
        b=ntU9gTuQrLAjzgcTJuBvrsNhEFi1CXPYz7hRq44rpMxEE9bRER0f120sHQL6jmrG/5
         G0A5LvkRcQ6OzYGwYcSQqWcEd2UmTBJAnjgI3RbKTw2usyWff3kwfyxjSzLMOqgOswD9
         4qh+QgZDazwRlG8mhpNzsLY+Anmsf0LZw3t3I84BsNlZQcbZp6M2yj+E6GyyIGp4Pinx
         QDv0i82I3fTtitXLRT1L0FDbDyZd4C1+ZhxDQx3b4oW0012YYeTYooShnCnY9+H3/xj/
         SR/aqt0HsGgBQuqKW1kykZ7Ds5mgzBugKyrRhO7K1hKAXo4ftTqvUDf9++1vl+DsLJXm
         PENw==
X-Gm-Message-State: APjAAAU1f+frN5h1kffU+9zA6+s2mKoa4VU8DG90UwFpHXQCcOkyiAx9
        6rDEcA8vIWAZ6aeBFgLuOrC+Ng==
X-Google-Smtp-Source: APXvYqxklCOsDdV1MV/DUmyJXW0OI6wPEgfwL5w2LWGA/7Ext3ku1cz65ETbe/3ANhe7bFewp78sEg==
X-Received: by 2002:a6b:d809:: with SMTP id y9mr26093434iob.301.1562045814232;
        Mon, 01 Jul 2019 22:36:54 -0700 (PDT)
Received: from x220t ([45.72.223.197])
        by smtp.gmail.com with ESMTPSA id x22sm10246314ioh.87.2019.07.01.22.36.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Jul 2019 22:36:53 -0700 (PDT)
Date:   Tue, 2 Jul 2019 01:36:47 -0400
From:   Alexander Aring <aring@mojatatu.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [RFC iproute2] netns: add mounting state file for each netns
Message-ID: <20190702053620.b7phijsgrhouoxxn@x220t>
References: <20190630192933.30743-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190630192933.30743-1-mcroce@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matteo,

On Sun, Jun 30, 2019 at 09:29:33PM +0200, Matteo Croce wrote:
> When ip creates a netns, there is a small time interval between the
> placeholder file creation in NETNS_RUN_DIR and the bind mount from /proc.
> 
> Add a temporary file named .mounting-$netns which gets deleted after the
> bind mount, so watching for delete event matching the .mounting-* name
> will notify watchers only after the bind mount has been done.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

thanks for working on it and making my mess better!
Would be nice to have it upstream.

- Alex
