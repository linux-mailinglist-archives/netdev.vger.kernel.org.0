Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD29A639119
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 22:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiKYVcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 16:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiKYVb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 16:31:59 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C6C167D6;
        Fri, 25 Nov 2022 13:31:58 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id C9F9C810FE;
        Fri, 25 Nov 2022 21:31:55 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669411918;
        bh=8CDJq028QJu4WvKMTC4XAxY7Or8lU48ysbXG0xj5lVM=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=KCwMQf8GXUIlanGvSTebAleX0dZUsn3/NmqK0GcSzzFwRMs3PhA+aMJwfs/G8/e7b
         Ghxsc6u8DAkbv6WD7tZrNPz9H1T4SJQONMPhB1dyiLiAwZbH0nopfB9CrCvhFjwXXU
         q5QCv9RVJ3Xevs9e333rvahQZHbLSpCg+7rbNj6bfSPr1818Dapqhr4STbAqag/+qO
         1UpChf188+w3fGZqQk/U2L/DrNVBD3WtJV0gC0xe5F3pMBd4t1qwETebkQjfc1opJa
         gZbygC/269FGFoyaRI2JGwV6UIUKvDqgzsBSWtWUOI0bzOQ+rkYOnCNtVSqOwK9PyS
         7xc1hdZfIte5A==
Message-ID: <df3bffca-17a4-d6fd-be56-46ff6c68b503@gnuweeb.org>
Date:   Sat, 26 Nov 2022 04:31:53 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20221121191459.998388-1-shr@devkernel.io>
 <20221121191459.998388-4-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH v5 3/4] liburing: add example programs for napi busy poll
In-Reply-To: <20221121191459.998388-4-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/22 2:14 AM, Stefan Roesch wrote:
> This adds two example programs to test the napi busy poll functionality.
> It consists of a client program and a server program. To get a napi id,
> the client and the server program need to be run on different hosts.
> 
> To test the napi busy poll timeout, the -t needs to be specified. A
> reasonable value for the busy poll timeout is 100. By specifying the
> busy poll timeout on the server and the client the best results are
> accomplished.
> 
> Signed-off-by: Stefan Roesch <shr@devkernel.io>

Since commit:

     fd6b571b0b03aeeb529f235c5c9c0a7c3256340c ("github: Add -Wmissing-prototypes for GitHub CI bot")

liburing GitHub CI robot enforces functions and global variables that
are not used outside the translation unit to be marked as static.

This patch fails the build.

GitHub CI says:

   clang -Werror -D_GNU_SOURCE -I../src/include/ -g -O3 -Wall -Wextra -Werror -Wmissing-prototypes -o napi-busy-poll-client napi-busy-poll-client.c -L../src/ -luring
   clang -Werror -D_GNU_SOURCE -I../src/include/ -g -O3 -Wall -Wextra -Werror -Wmissing-prototypes -o napi-busy-poll-server napi-busy-poll-server.c -L../src/ -luring
   napi-busy-poll-client.c:78:6: error: no previous prototype for function 'printUsage' [-Werror,-Wmissing-prototypes]
   void printUsage(const char *name)
        ^
   napi-busy-poll-client.c:78:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void printUsage(const char *name)
   ^
   static
   napi-busy-poll-client.c:102:6: error: no previous prototype for function 'printError' [-Werror,-Wmissing-prototypes]
   void printError(const char *msg, int opt)
        ^
   napi-busy-poll-client.c:102:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void printError(const char *msg, int opt)
   ^
   static
   napi-busy-poll-client.c:108:6: error: no previous prototype for function 'setProcessScheduler' [-Werror,-Wmissing-prototypes]
   void setProcessScheduler(void)
        ^
   napi-busy-poll-client.c:108:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void setProcessScheduler(void)
   ^
   static
   napi-busy-poll-client.c:118:8: error: no previous prototype for function 'diffTimespec' [-Werror,-Wmissing-prototypes]
   double diffTimespec(const struct timespec *time1, const struct timespec *time0)
          ^
   napi-busy-poll-client.c:118:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   double diffTimespec(const struct timespec *time1, const struct timespec *time0)
   ^
   static
   napi-busy-poll-client.c:124:10: error: no previous prototype for function 'encodeUserData' [-Werror,-Wmissing-prototypes]
   uint64_t encodeUserData(char type, int fd)
            ^
   napi-busy-poll-client.c:124:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   uint64_t encodeUserData(char type, int fd)
   ^
   static
   napi-busy-poll-client.c:129:6: error: no previous prototype for function 'decodeUserData' [-Werror,-Wmissing-prototypes]
   void decodeUserData(uint64_t data, char *type, int *fd)
        ^
   napi-busy-poll-client.c:129:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void decodeUserData(uint64_t data, char *type, int *fd)
   ^
   static
   napi-busy-poll-client.c:135:13: error: no previous prototype for function 'opTypeToStr' [-Werror,-Wmissing-prototypes]
   const char *opTypeToStr(char type)
               ^
   napi-busy-poll-client.c:135:7: note: declare 'static' if the function is not intended to be used outside of this translation unit
   const char *opTypeToStr(char type)
         ^
   static
   napi-busy-poll-client.c:159:6: error: no previous prototype for function 'reportNapi' [-Werror,-Wmissing-prototypes]
   void reportNapi(struct ctx *ctx)
        ^
   napi-busy-poll-client.c:159:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void reportNapi(struct ctx *ctx)
   ^
   static
   napi-busy-poll-client.c:173:6: error: no previous prototype for function 'sendPing' [-Werror,-Wmissing-prototypes]
   void sendPing(struct ctx *ctx)
        ^
   napi-busy-poll-client.c:173:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void sendPing(struct ctx *ctx)
   ^
   static
   napi-busy-poll-client.c:183:6: error: no previous prototype for function 'receivePing' [-Werror,-Wmissing-prototypes]
   void receivePing(struct ctx *ctx)
        ^
   napi-busy-poll-client.c:183:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void receivePing(struct ctx *ctx)
   ^
   static
   napi-busy-poll-client.c:191:6: error: no previous prototype for function 'recordRTT' [-Werror,-Wmissing-prototypes]
   void recordRTT(struct ctx *ctx)
        ^
   napi-busy-poll-client.c:191:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void recordRTT(struct ctx *ctx)
   ^
   static
   napi-busy-poll-client.c:203:6: error: no previous prototype for function 'printStats' [-Werror,-Wmissing-prototypes]
   void printStats(struct ctx *ctx)
        ^
   napi-busy-poll-client.c:203:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void printStats(struct ctx *ctx)
   ^
   static
   napi-busy-poll-client.c:230:5: error: no previous prototype for function 'completion' [-Werror,-Wmissing-prototypes]
   int completion(struct ctx *ctx, struct io_uring_cqe *cqe)
       ^
   napi-busy-poll-client.c:230:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int completion(struct ctx *ctx, struct io_uring_cqe *cqe)
   ^
   static
   13 errors generated.
   make[1]: *** [Makefile:38: napi-busy-poll-client] Error 1
   make[1]: *** Waiting for unfinished jobs....
   napi-busy-poll-server.c:78:6: error: no previous prototype for function 'printUsage' [-Werror,-Wmissing-prototypes]
   void printUsage(const char *name)
        ^
   napi-busy-poll-server.c:78:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void printUsage(const char *name)
   ^
   static
   napi-busy-poll-server.c:104:6: error: no previous prototype for function 'printError' [-Werror,-Wmissing-prototypes]
   void printError(const char *msg, int opt)
        ^
   napi-busy-poll-server.c:104:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void printError(const char *msg, int opt)
   ^
   static
   napi-busy-poll-server.c:110:6: error: no previous prototype for function 'setProcessScheduler' [-Werror,-Wmissing-prototypes]
   void setProcessScheduler()
        ^
   napi-busy-poll-server.c:110:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void setProcessScheduler()
   ^
   static
   napi-busy-poll-server.c:120:10: error: no previous prototype for function 'encodeUserData' [-Werror,-Wmissing-prototypes]
   uint64_t encodeUserData(char type, int fd)
            ^
   napi-busy-poll-server.c:120:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   uint64_t encodeUserData(char type, int fd)
   ^
   static
   napi-busy-poll-server.c:125:6: error: no previous prototype for function 'decodeUserData' [-Werror,-Wmissing-prototypes]
   void decodeUserData(uint64_t data, char *type, int *fd)
        ^
   napi-busy-poll-server.c:125:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void decodeUserData(uint64_t data, char *type, int *fd)
   ^
   static
   napi-busy-poll-server.c:131:13: error: no previous prototype for function 'opTypeToStr' [-Werror,-Wmissing-prototypes]
   const char *opTypeToStr(char type)
               ^
   napi-busy-poll-server.c:131:7: note: declare 'static' if the function is not intended to be used outside of this translation unit
   const char *opTypeToStr(char type)
         ^
   static
   napi-busy-poll-server.c:155:6: error: no previous prototype for function 'reportNapi' [-Werror,-Wmissing-prototypes]
   void reportNapi(struct ctx *ctx)
        ^
   napi-busy-poll-server.c:155:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void reportNapi(struct ctx *ctx)
   ^
   static
   napi-busy-poll-server.c:169:6: error: no previous prototype for function 'sendPing' [-Werror,-Wmissing-prototypes]
   void sendPing(struct ctx *ctx)
        ^
   napi-busy-poll-server.c:169:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void sendPing(struct ctx *ctx)
   ^
   static
   napi-busy-poll-server.c:178:6: error: no previous prototype for function 'receivePing' [-Werror,-Wmissing-prototypes]
   void receivePing(struct ctx *ctx)
        ^
   napi-busy-poll-server.c:178:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void receivePing(struct ctx *ctx)
   ^
   static
   napi-busy-poll-server.c:193:6: error: no previous prototype for function 'completion' [-Werror,-Wmissing-prototypes]
   void completion(struct ctx *ctx, struct io_uring_cqe *cqe)
        ^
   napi-busy-poll-server.c:193:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void completion(struct ctx *ctx, struct io_uring_cqe *cqe)
   ^
   static
   10 errors generated.
   make[1]: *** [Makefile:38: napi-busy-poll-server] Error 1
   make: *** [Makefile:12: all] Error 2
   make[1]: Leaving directory '/home/runner/work/liburing/liburing/examples'
   Error: Process completed with exit code 2.

-- 
Ammar Faizi

