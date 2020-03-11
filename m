Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6312180E94
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 04:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgCKDf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 23:35:56 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:38265 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbgCKDf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 23:35:56 -0400
Received: by mail-qv1-f65.google.com with SMTP id p60so246038qva.5;
        Tue, 10 Mar 2020 20:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i3na/G2UNw5hnKYINRHGCdUxynS4ZkJFF4DGtdT+Dj4=;
        b=gS4FCqbSqzihSUuLcPUicLXB/vkSPdL/y0/VVFKU/CzIYAjWKWZAbhp0cpUbCcu3kC
         +A+zKufpAuTqj1Y5MIWwJgDXoeGqsI5R38QQTknI0dom9e/t7MtUDJARsvEWiVvja7FD
         aG0b8wGfWViR2LSMtNHNzcJiDf9gNXPysynHADJI3I+Vct6ZSQlzwOVOLo82o/OkxHy6
         V+HcuiuqKVnC0f0eeDjWJJOGXobdlBARmZizvUc7QFokFcBhQdZDH/gls/57GdaqnGZZ
         JTaOX8kIjWkS2sNyItHbbQcMV/Mp3MRGp1tG/0eAgA3XOrWJQVvDq8vGGZ1x539Trata
         +SvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i3na/G2UNw5hnKYINRHGCdUxynS4ZkJFF4DGtdT+Dj4=;
        b=iWQz8dDW3hoKvxYGQX6qyr8Vkn3aAXiOSGIPeRmtYPII2DwRVgoO0SUIdfRLU+VuTI
         LntkwjV2XzSc+nlAcn+AoCH2l35q0I3v/h6Bu+hILCezat9FdrHBBTzXDyA7AiqPVl5A
         HDB6SegwqoPhEkFR2Y1aEyucGITtbU7y/mViycyLK5i4SmmcFvJHxiFuph/YKrmSFmtr
         bxXZ5PmAuZiLDKVSrJBbLEhvKcXTkENKiom4Ooio2nZujE9KFmfPJ0A/pTXrmyDzo+1P
         QteIojbYQpWVI16zq3GnaCI0ac9HIFWGY0gN49r20AOsTUvRjFWey8AYqSLLwLoY08mS
         zaqw==
X-Gm-Message-State: ANhLgQ10EkVeILH1znPeNDni6dK1Y40juzfK89L3pymakKJkDNCRzLwL
        332+P73vOHvozGKGk8U6gIU=
X-Google-Smtp-Source: ADFU+vv9ovLQhBEMGRKW1W3INTXF5mdFmgdi4Ezigra+fJ3KtHD2ISFaYZ3lpTDn4em6OshpX7IU8g==
X-Received: by 2002:ad4:458d:: with SMTP id x13mr1051995qvu.155.1583897755156;
        Tue, 10 Mar 2020 20:35:55 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f028:aa40:30e3:a413:313c:50ab])
        by smtp.gmail.com with ESMTPSA id d72sm4682657qkg.102.2020.03.10.20.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 20:35:54 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4D7CEC163B; Wed, 11 Mar 2020 00:35:52 -0300 (-03)
Date:   Wed, 11 Mar 2020 00:35:52 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, nhorman@tuxdriver.com,
        jere.leppanen@nokia.com, michael.tuexen@lurchi.franken.de
Subject: Re: [PATCH net] sctp: return a one-to-one type socket when doing
 peeloff
Message-ID: <20200311033552.GE2547@localhost.localdomain>
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
 <20200309.180949.633904935953558472.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309.180949.633904935953558472.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 06:09:49PM -0700, David Miller wrote:
> From: Xin Long <lucien.xin@gmail.com>
> Date: Mon,  2 Mar 2020 14:57:15 +0800
> 
> > As it says in rfc6458#section-9.2:
> > 
> >   The application uses the sctp_peeloff() call to branch off an
> >   association into a separate socket.  (Note that the semantics are
> >   somewhat changed from the traditional one-to-one style accept()
> >   call.)  Note also that the new socket is a one-to-one style socket.
> >   Thus, it will be confined to operations allowed for a one-to-one
> >   style socket.
> > 
> > Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
> > on which some operations are not allowed, like shutdown, as Jere
> > reported.
> > 
> > This patch is to change it to return a one-to-one type socket instead.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Leppanen, Jere (Nokia - FI/Espoo) <jere.leppanen@nokia.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> I don't know what to do with this patch.
> 
> There seems to be some discussion about a potential alternative approach
> to the fix, but there were problems with that suggestion.
> 
> Please advise, thank you.

Please drop it. As you noticed, we do need more discussions around
it. Thanks.
