Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279D03B9F46
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 12:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhGBKu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 06:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbhGBKuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 06:50:50 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998D2C061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 03:48:17 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so9696027otl.0
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 03:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rUmBA0QB8KFtmwggWY3IlnbWkVqw0L4qDRcAcMC5Ny0=;
        b=Uv+wNjkoZPE7ZqDzQO2A97xScQsI2vhgdM+KGg23pM15y+CDGLmnYRWu5VeBYE9UaV
         SbeqZu4uU2L3PauOASGwI1rEhCt5VgZQDhPbcUgDbd2EJ8cYyNhgRFpzAfu8+3d7gd2C
         r/9H/fUE6t8kIkmvaxqguQfPgs6tC1JU981aUdBTi3anJgPQXlrIqKT0Y3oTM/9hCSa7
         jUwXjxS0U/x73l3EBuNNqujEgSesEzNYQZFWfpDcwkwcJ81Jqndfgw1KFZ8AHs2DSmq+
         akXV7aLi2fwi3L5TYFzEkRaYX/1D9pOC3piqBvxBz1z1xl3zC+AnDOwHpSvGltqvlt95
         v80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rUmBA0QB8KFtmwggWY3IlnbWkVqw0L4qDRcAcMC5Ny0=;
        b=QZtH52fYPe0MYQEdCdSVRAI2ftUE32BR4mU73TdugPFBJIi+eudkmvS2GLt2ES3oC4
         aIhlEYhJ+eXN+GI/A5Y0LfdQI/0kidbO/P6oW3ojnhtms3iL4sLhRK+qbV27lN4trjwy
         059nu2GhvZ895N7jna3C2UXlIGiPNoKOD+zwqvhYjB76wE3jG95FSEdurdhDV4NEAISA
         TJ2SyPv0oIPKRJZ9clV6eXMFsQHyLD/75Dk6aA1Z05abQ8pwnlojL9wPmyt41FP5q+sO
         Swqe7YxBZeps2OSo4PJzFvZypnXb6j8UrzuE8p5n17sdWF+iW1OXfcXdMTIZgcXzz1Fk
         Pm/g==
X-Gm-Message-State: AOAM5301S/OACL+O3YNFUqWO+rrtgsQ0fQ+RcXUgSJ9HaoPPvlGjyYYp
        ASttJyXsf8aQQa1QIoLRtCDBJKFq1wyFmU7jIHs=
X-Google-Smtp-Source: ABdhPJzrulo2Wo4ssJgTpqnT6QsvZQSaHJV9ARlBvVPQjRjytzD8980tZtCbmKIfM7XkGEcWD+clQGaCjAwL5q8F5a4=
X-Received: by 2002:a9d:2649:: with SMTP id a67mr3953471otb.181.1625222897049;
 Fri, 02 Jul 2021 03:48:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210701150745.1005098-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20210701150745.1005098-1-m.chetan.kumar@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 2 Jul 2021 13:48:05 +0300
Message-ID: <CAHNKnsT2zwemazCqqU+oX+7-eOT6jtwUp8=7XTZKdMNnqyB_Ag@mail.gmail.com>
Subject: Re: [PATCH V2 3/5] net: wwan: iosm: correct link-id handling
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        krishna.c.sudi@intel.com, Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 6:10 PM M Chetan Kumar
<m.chetan.kumar@linux.intel.com> wrote:
> Link ID to be kept intact with MBIM session ID
> Ex: ID 0 should be associated to MBIM session ID 0.
>
> Reported-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

For the record:

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
